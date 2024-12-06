import 'package:flutter/material.dart';
import '../services/soap_service.dart';
class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';

  // Método para manejar el login
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await SoapService().login(username, password);

      // Revisamos si el resultado contiene "OK" (o el valor de éxito que el servicio devuelve)
      if (response.result.contains("OK")) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _responseMessage = 'Usuario o contraseña incorrectos.';
        });
      }
      print('Resultado del servidor: ${response.result}');
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
      print('Error en la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login SOAP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 20),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
