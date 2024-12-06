import 'package:flutter/material.dart';
import 'package:proyecto_sig/views/login_view.dart';
import 'views/home_view.dart';
import 'views/lectura_view.dart';
import 'views/cortes_view.dart';
import 'views/reconexion_view.dart';
import 'views/importar_cortes_view.dart';
import 'views/registrar_cortes_view.dart';
import 'views/exportar_cortes_view.dart';
import 'views/lista_cortes_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menú Principal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/lectura': (context) => LecturaView(),
        '/cortes': (context) => CortesView(),
        '/reconexion': (context) => ReconexionView(),
        '/importar_cortes': (context) => ImportarCortesView(),
        '/registrar_cortes': (context) => RegistrarCortesView(),
        '/exportar_cortes': (context) => ExportarCortesView(),
        '/lista_cortes': (context) => ListaCortesView(),
      },
    );
  }
}
