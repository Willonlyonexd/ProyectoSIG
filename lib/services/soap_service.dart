import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/login_response.dart';
import 'package:dio/dio.dart';

class SoapService {
  static const String _url = 'http://190.171.244.211:8080/wsVarios/wsAd.asmx';

  // Método para el login
  Future<LoginResponse> login(String username, String password) async {
    final soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <ValidarLoginPassword xmlns="http://tempuri.org/">
          <lsLogin>$username</lsLogin>
          <lsPassword>$password</lsPassword>
        </ValidarLoginPassword>
      </soap:Body>
    </soap:Envelope>''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://tempuri.org/ValidarLoginPassword',
      },
      body: soapEnvelope,
    );

    if (response.statusCode == 200) {
      print('Respuesta del servidor: ${response.body}');
      return LoginResponse.fromXml(response.body);
    } else {
      throw Exception('Error al hacer la solicitud: ${response.statusCode}');
    }
  }

  // Método para obtener las rutas disponibles
  Future<List<Map<String, String>>> obtenerRutasConDio(int liCper) async {
    final dio = Dio();

    final soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
      <liCper>$liCper</liCper>
    </W0Corte_ObtenerRutas>
  </soap:Body>
</soap:Envelope>
''';

    try {
      // Enviar solicitud SOAP con Dio
      final response = await dio.post(
        'http://190.171.244.211:8080/wsVarios/wsBS.asmx',
        data: soapEnvelope,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': '"http://activebs.net/W0Corte_ObtenerRutas"',
          },
        ),
      );

      // Logs detallados
      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta:\n${response.data}');

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);

        // Extraer las rutas
        final rutas = document
            .findAllElements('Table')
            .map((table) => {
                  'id': table.findElements('bsrutnrut').first.text,
                  'descripcion':
                      table.findElements('bsrutdesc').first.text.trim(),
                  'zona': table.findElements('dNzon').first.text.trim(),
                })
            .toList();

        return rutas;
      } else {
        throw Exception('Error al obtener rutas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar rutas: $e');
      rethrow;
    }
  }

  // Método para obtener los puntos de corte
  Future<List<Map<String, dynamic>>> obtenerReporteParaCortes(
      int liNrut, int liNcnt, int liCper) async {
    final dio = Dio();

    final soapEnvelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W2Corte_ReporteParaCortesSIG xmlns="http://activebs.net/">
      <liNrut>$liNrut</liNrut>
      <liNcnt>$liNcnt</liNcnt>
      <liCper>$liCper</liCper>
    </W2Corte_ReporteParaCortesSIG>
  </soap:Body>
</soap:Envelope>
''';

    try {
      final response = await dio.post(
        'http://190.171.244.211:8080/wsVarios/wsBS.asmx',
        data: soapEnvelope,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': '"http://activebs.net/W2Corte_ReporteParaCortesSIG"',
          },
        ),
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);

        // Procesar los datos de la respuesta
        final puntos = document
            .findAllElements('Table')
            .map((table) => {
                  'bscocNcoc': table.findElements('bscocNcoc').first.text,
                  'bscntCodf': table.findElements('bscntCodf').first.text,
                  'dNomb': table.findElements('dNomb').first.text,
                  'dNcat': table.findElements('dNcat').first.text,
                  'bscocNmor': table.findElements('bscocNmor').first.text,
                  'bscocImor': table.findElements('bscocImor').first.text,
                  'bsmednser': table.findElements('bsmednser').first.text,
                  'bsmedNume': table.findElements('bsmedNume').first.text,
                  'bscntlati': table.findElements('bscntlati').first.text,
                  'bscntlogi': table.findElements('bscntlogi').first.text,
                  'dCobc': table.findElements('dCobc').first.text,
                })
            .toList();

        return puntos;
      } else {
        throw Exception('Error al obtener puntos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}