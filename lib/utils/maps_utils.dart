import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<List<LatLng>> getRoute(List<Marker> markers) async {
  final origin = markers.first.position; // Primer punto (origen)
  final destination = markers.last.position; // Último punto (destino)

  // Convertimos las posiciones de los markers a la sintaxis de la API Directions
  final waypoints = markers
      .skip(1)
      .take(markers.length - 2) // Excluir el primer y último punto
      .map((marker) =>
          '${marker.position.latitude},${marker.position.longitude}')
      .join('|'); // Concatenar los waypoints con '|' entre ellos

  // Construir la URL para la solicitud a la API de Directions
  const apiKey =
      'AIzaSyDsjSlGM22AdrCuoNyFn-h4wLqeRjswZQc'; // Reemplaza con tu API Key
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&waypoints=$waypoints&key=$apiKey');

  // Realizamos la solicitud GET a la API de Directions
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Si la respuesta es correcta, procesamos el resultado
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      // Parseamos la ruta (polyline)
      final route = data['routes'][0]['legs'] as List;
      List<LatLng> routePoints = [];

      // Recorremos las coordenadas de la ruta y las agregamos a la lista
      for (var leg in route) {
        for (var step in leg['steps']) {
          final lat = step['end_location']['lat'];
          final lng = step['end_location']['lng'];
          routePoints.add(LatLng(lat, lng));
        }
      }

      return routePoints; // Retornamos los puntos de la ruta
    } else {
      throw Exception('Error en la solicitud: ${data['status']}');
    }
  } else {
    throw Exception('Error en la conexión a la API: ${response.statusCode}');
  }
}
