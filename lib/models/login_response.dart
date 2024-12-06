import 'package:xml/xml.dart';

class LoginResponse {
  final String result;

  LoginResponse({required this.result});

  factory LoginResponse.fromXml(String xml) {
    final document = XmlDocument.parse(xml);
    final resultElement = document
        .findAllElements('ValidarLoginPasswordResult')
        .first
        .text;

    return LoginResponse(result: resultElement);
  }
}
