import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  late GoogleMapController mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Llamar a la función que obtiene la ubicación actual
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si no está habilitado, muestra un mensaje y regresa
      print("Ubicación deshabilitada.");
      return;
    }

    // Verificar el permiso de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permiso de ubicación denegado.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Permiso de ubicación denegado de forma permanente.");
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Mover el mapa a la ubicación actual
    mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            bearing: 192.8334901395799,
            target: _currentPosition,
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("current_location"),
              position: _currentPosition,
              infoWindow: const InfoWindow(title: "Mi ubicación"),
            ),
          },
        ),
      ),
    );
  }
}
