import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMaps extends StatefulWidget {
  const GMaps({super.key});

  @override
  State<GMaps> createState() => _GMapsState();
}

class _GMapsState extends State<GMaps> {
  late GoogleMapController googleMapController;

  Future<void> _getCurrentLocation() async {
    print("position");
    // final position = await Geolocator.getCurrentPosition();
    // Update the camera position of the Google Map
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(10, 10), zoom: 11)
          // LatLng(10, 10),
          // 15,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: GoogleMap(
          zoomControlsEnabled: false,
          markers: {
            const Marker(
              markerId: MarkerId("demo"),
              infoWindow: InfoWindow(title: "Hey"),
              position: LatLng(10, 10),
              // draggable: true,
            )
          },
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          initialCameraPosition:
              CameraPosition(target: LatLng(10, 10), zoom: 14),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
