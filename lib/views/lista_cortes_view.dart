import 'package:flutter/material.dart';

class ListaCortesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Cortes Realizados'),
      ),
      body: Center(
        child: Text('Aquí irá la lista de los cortes realizados.'),
      ),
    );
  }
}
