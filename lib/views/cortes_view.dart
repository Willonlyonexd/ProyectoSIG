import 'package:flutter/material.dart';

class CortesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cortes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Importar cortes desde el servidor
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/importar_cortes');
              },
              child: Text('Importar cortes desde el servidor'),
            ),
            SizedBox(height: 20),

            // Botón Registrar Cortes
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registrar_cortes');
              },
              child: Text('Registrar Cortes'),
            ),
            SizedBox(height: 20),

            // Botón Exportar cortes al servidor
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/exportar_cortes');
              },
              child: Text('Exportar cortes al servidor'),
            ),
            SizedBox(height: 20),

            // Botón Lista de cortes realizados
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lista_cortes');
              },
              child: Text('Lista de cortes realizados'),
            ),
            SizedBox(height: 20),

            // Botón Salir
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volver al menú principal
              },
              child: Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
