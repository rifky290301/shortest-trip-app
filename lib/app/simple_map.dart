import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skrispsi_app/app/simple_map_controller.dart';

class MapSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimpleMapController>(
      init: Get.put(SimpleMapController()),
      builder: (ctrl) {
        return ctrl.isLoading
            ? Scaffold(
                body: Stack(
                  children: [
                    GoogleMap(
                      // myLocationEnabled: true,
                      // compassEnabled: true,
                      // mapType: MapType.normal,
                      // polylines: ctrl.polylines,
                      // trafficEnabled: true,
                      markers: Set<Marker>.of(ctrl.markers),
                      // polylines: Set<Polyline>.of(ctrl.polylines),
                      polylines: ctrl.polylines,
                      initialCameraPosition: ctrl.initialGoogleMap,
                      onMapCreated: (GoogleMapController controller) {
                        ctrl.controllerGoogleMap.complete(controller);
                      },
                      onTap: (argument) {
                        ctrl.addLocationMarker(lat: argument.latitude, lng: argument.longitude);
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       hintText: 'Search',
                    //       fillColor: Colors.white,
                    //       filled: true,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: const BorderSide(),
                    //       ),
                    //       suffixIcon: const Icon(Icons.search),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 30,
                      left: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.generateLines();
                        },
                        child: const Text('Show Route'),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await ctrl.gotoCurrentLocation();
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.location_searching, color: Colors.blue),
                ),
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
