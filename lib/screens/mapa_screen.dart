import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/scan_model.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
    ModalRoute
        .of(context)!
        .settings
        .arguments as ScanModel;

    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );

    // Definir puntos en el mapa
    markers.add(Marker(position: scan.getLatLng(), markerId: MarkerId('id1')));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: markers,
              initialCameraPosition: _puntInicial,
              //FUNCIONALITATS AFEGIDES
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}