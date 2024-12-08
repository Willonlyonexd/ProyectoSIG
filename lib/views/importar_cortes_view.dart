import 'package:flutter/material.dart';
import '../services/soap_service.dart';

class ImportarCortesView extends StatefulWidget {
  const ImportarCortesView({super.key});

  @override
  _ImportarCortesViewState createState() => _ImportarCortesViewState();
}

class _ImportarCortesViewState extends State<ImportarCortesView> {
  final SoapService _soapService = SoapService();
  List<Map<String, dynamic>> rutas = [];
  List<Map<String, dynamic>> puntosDeCorte = [];
  List<Map<String, dynamic>> puntosFiltrados = [];
  String? rutaSeleccionada;
  String codigoFijo = '';
  String filtroNombre = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarRutas();
  }

  Future<void> _cargarRutas() async {
    setState(() {
      isLoading = true;
    });

    try {
      final resultado =
          await _soapService.obtenerRutasConDio(1); // Cambiar según contexto
      setState(() {
        rutas = resultado;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar rutas: $e');
    }
  }

  Future<void> _obtenerPuntosDeZona() async {
    if (rutaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor selecciona una zona'),
      ));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final puntos = await _soapService.obtenerReporteParaCortes(
        int.parse(rutaSeleccionada!), // ID de la ruta seleccionada
        0, // Código fijo no se usa aquí
        1, // Período actual (ajustar si es necesario)
      );

      setState(() {
        puntosDeCorte = puntos;
        puntosFiltrados = puntosDeCorte; // Inicialmente mostramos todos
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener puntos: $e');
    }
  }

  void _buscarPorCodigoFijo() {
    if (codigoFijo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor ingresa un código fijo'),
      ));
      return;
    }

    setState(() {
      puntosFiltrados = puntosDeCorte.where((punto) {
        final codigoFijoPunto = punto['bscntCodf']?.toString() ?? '';
        return codigoFijoPunto.contains(codigoFijo);
      }).toList();
    });
  }

  void _filtrarPuntos(String texto) {
    setState(() {
      filtroNombre = texto;
      puntosFiltrados = puntosDeCorte
          .where((punto) =>
              punto['dNomb']
                  ?.toLowerCase()
                  .contains(filtroNombre.toLowerCase()) ??
              false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar Cortes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/prueba');
        },
        child: const Text('Ver ruta'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Selector de zona
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Selecciona una zona'),
                    value: rutaSeleccionada,
                    items: rutas.map((ruta) {
                      return DropdownMenuItem(
                        value: ruta['id']!.toString(),
                        child: Text('${ruta['descripcion']} (${ruta['zona']})'),
                      );
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        rutaSeleccionada = valor;
                        puntosDeCorte.clear(); // Limpiamos los puntos
                        puntosFiltrados.clear();
                      });
                      _obtenerPuntosDeZona(); // Cargamos los puntos de la zona seleccionada
                    },
                  ),
                ),
                // Campo para "Código Fijo"
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Código Fijo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (valor) {
                      codigoFijo = valor;
                    },
                  ),
                ),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _obtenerPuntosDeZona,
                      child: const Text('Puntos de Zona'),
                    ),
                    ElevatedButton(
                      onPressed: _buscarPorCodigoFijo,
                      child: const Text('Buscar Código Fijo'),
                    ),
                  ],
                ),
                // Buscador
                if (puntosDeCorte.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Buscar por nombre',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _filtrarPuntos,
                    ),
                  ),
                // Lista de resultados
                Expanded(
                  //enviar solo 10 resultados a la siguiente pagina
                  child: puntosFiltrados.isEmpty
                      ? const Center(child: Text('No hay puntos para mostrar'))
                      : ListView.builder(
                          itemCount: puntosFiltrados.length,
                          itemBuilder: (context, index) {
                            final punto = puntosFiltrados[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(
                                    punto['dNomb'] ?? 'Sin nombre',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Categoría: ${punto['dNcat'] ?? 'Desconocida'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Código Fijo: ${punto['bscntCodf'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Latitud: ${punto['bscntlati'] ?? 'N/A'}, Longitud: ${punto['bscntlogi'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Deuda: ${punto['bscocImor'] ?? '0.0'} USD | Mora: ${punto['bscocNmor'] ?? '0'} meses',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      if (punto['dLotes'] != null &&
                                          punto['dLotes']!.isNotEmpty)
                                        Text(
                                          'Lote: ${punto['dLotes']}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'ID: ${punto['bscocNcoc'] + 'asas' ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
