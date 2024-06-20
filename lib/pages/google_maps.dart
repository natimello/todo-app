import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:todo_project/pages/widgets/custom_app_bar.dart';
import 'package:todo_project/pages/widgets/menu_drawer.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.8670522, 151.1957362);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mapa',
      ),
      drawer: MenuDrawer(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
