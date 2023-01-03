import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';

class SimpleMapController extends GetxController {
  final Completer<GoogleMapController> controllerGoogleMap = Completer();
  bool isLoading = false;
  late CameraPosition initialGoogleMap;
  late List<Marker> markers = [];

  void addLocationMarker({required double lat, required double lng}) {
    print('lat: $lat, lng: $lng');
    String id = (markers.length + 1).toString();
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        draggable: true,
        infoWindow: InfoWindow(
          title: 'Position $id',
          snippet: '$lat, $lng',
          onTap: () {
            deleteMarker(MarkerId(id));
          },
        ),
      ),
    );
    update();
  }

  void deleteMarker(MarkerId markerId) {
    markers.removeWhere((marker) => marker.markerId == markerId);
    update();
  }

  Future<void> gotoCurrentLocation() async {
    final GoogleMapController controller = await controllerGoogleMap.future;
    getUserCurrentLocation().then((value) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 16,
        ),
      ));
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

// !------------------------------------------------------------------------------------------------------------------------

  // PolylinePoints polylinePoints = PolylinePoints();
  // Map<PolylineId, Polyline> polylines = {};
  late Set<Polyline> polylines = {};
  // Set<Polyline> polylines = {};

  List<List<double>> temp = [
    [-8.167338055438705, 113.70853934437035],
    [-8.165251880296916, 113.71313095092773],
    [-8.169640269472676, 113.71153805404902],
  ];

  Future<void> getPolyPoints({
    required String idLine,
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.apiKey,
      PointLatLng(lat1, lng1),
      PointLatLng(lat2, lng2),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    List colors = [Colors.red, Colors.green, Colors.yellow];
    Random random = Random();

    polylines.add(
      Polyline(
        polylineId: PolylineId(idLine),
        color: colors[random.nextInt(3)],
        points: polylineCoordinates,
        width: 4,
      ),
    );
  }

  void generateLines() async {
    for (var i = 0; i < temp.length - 1; i++) {
      await getPolyPoints(
        idLine: i.toString(),
        lat1: temp[i][0],
        lng1: temp[i][1],
        lat2: temp[i + 1][0],
        lng2: temp[i + 1][1],
      );
      update();
    }
    print('-------------------------------------------- ');
    inspect(polylines);
    print('-------------------------------------------- ');
  }

  // addPolyLine() {
  //   PolylineId id = const PolylineId("poly");
  //   Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
  //   polylines[id] = polyline;
  //   update();
  // }

  // void makeLines() async {
  //   await polylinePoints
  //       .getRouteBetweenCoordinates(
  //           Constants.apiKey,
  //           const PointLatLng(-8.1688904, 113.7117308), //Starting LATLANG
  //           const PointLatLng(-8.174514467755436, 113.71223174035549), //End LATLANG
  //           travelMode: TravelMode.driving)
  //       .then((value) {
  //     for (var point in value.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   }).then((value) {
  //     addPolyLine();
  //   });
  // }

// !------------------------------------------------------------------------------------------------------------------------

  @override
  void onInit() async {
    super.onInit();
    await getUserCurrentLocation().then((value) {
      initialGoogleMap = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 16,
      );
      markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'My Current Location',
          ),
        ),
      );
    });
    isLoading = true;
    update();
  }
}
