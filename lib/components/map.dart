// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMaps extends StatefulWidget {
  const GMaps({Key? key, required this.coordinates}) : super(key: key);

  final Map<String, double> coordinates;

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
        CameraPosition(
          target:
              LatLng(widget.coordinates['lat']!, widget.coordinates['lng']!),
          zoom: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Container(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              )),
          title: Text(
            "Map",
            style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(149, 255, 255, 255)),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
                width: 57,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: const Icon(
                      Icons.bookmark_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                )),
          ]),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: GoogleMap(
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: MarkerId("demo"),
              infoWindow: InfoWindow(title: "Hey"),
              position: LatLng(
                  widget.coordinates['lat']!, widget.coordinates['lng']!),
              // draggable: true,
            )
          },
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.coordinates['lat']!, widget.coordinates['lng']!),
              zoom: 14),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
