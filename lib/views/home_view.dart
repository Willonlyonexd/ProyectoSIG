import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Lectura
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lectura');
              },
              child: Text('Lectura'),
            ),
            SizedBox(height: 20),

            // Botón Cortes
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cortes');
              },
              child: Text('Cortes'),
            ),
            SizedBox(height: 20),

            // Botón Reconexión
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reconexion');
              },
              child: Text('Reconexión'),
            ),
            SizedBox(height: 20),

            // Botón Salir
            ElevatedButton(
              onPressed: () {
                // Salir de la aplicación
                Navigator.pop(context); // Volver al login
              },
              child: Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
