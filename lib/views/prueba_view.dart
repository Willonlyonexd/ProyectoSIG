import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_sig/utils/maps_utils.dart';

class PruebaView extends StatefulWidget {
  final List<Map<String, dynamic>> puntos;
  const PruebaView({super.key, required this.puntos});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  late GoogleMapController mapController;
  List<LatLng> polylineCoordinates = []; // Coordenadas de la ruta
  late LatLng _currentPosition =
      const LatLng(0, 0); // Guardaremos la ubicación actual
  late CameraPosition _initialPosition = CameraPosition(target: LatLng(0, 0));
  List markers = [];
  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtenemos la ubicación al iniciar
    setMarkers();
  }

  void setMarkers() {
    setState(() {
      markers = widget.puntos.map((punto) {
        return Marker(
          markerId: MarkerId(punto['bscocNcoc'].toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(
            double.parse(punto['bscntlati'].toString()),
            double.parse(punto['bscntlogi'].toString()),
          ),
          infoWindow: InfoWindow(title: punto['dNomb'].toString()),
        );
      }).toList();
      getRoute(List<Marker>.from(markers)).then((coordinates) {
        setState(() {
          polylineCoordinates = coordinates;
        });
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    // Verificar los permisos de ubicación
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si el servicio de ubicación no está habilitado, muestra un mensaje
      print("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Si el permiso es denegado, muestra un mensaje
        print("Location permissions are denied");
        return;
      }
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Actualizar la posición actual
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _initialPosition = CameraPosition(
        target: _currentPosition,
        zoom: 14.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Marker mark = markers.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Example'),
      ),
      body: _currentPosition == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Muestra cargando hasta que obtenga la ubicación
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: markers.first.position,
                zoom: 12,
              ),
              markers: Set.from(markers),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
    );
  }
}
