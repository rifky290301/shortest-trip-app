import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';

class SimpleMapController extends GetxController {
  final Completer<GoogleMapController> controllerGoogleMap = Completer();
  late CameraPosition initialGoogleMap;

  bool isLoading = false;
  bool isPopUp = false;
  List<Marker> markers = [];
  Set<Polyline> polylines = {};
  List<List<double>> latLngPoint = [];
  List<Map<String, dynamic>> distanceLines = [];

  void matrixDistance() {
    List<List<int>> matriks = [];
    for (int i = 0; i < latLngPoint.length; i++) {
      List<int> temp = [];
      for (int j = 0; j < latLngPoint.length; j++) {
        temp.add(distanceTwoPoint(latLngPoint[i][0], latLngPoint[i][1], latLngPoint[j][0], latLngPoint[j][1]));
      }
      matriks.add(temp);
    }
    // return matriks;
    // print(matriks);
    // inspect(matriks);
  }

  void addLocationMarker({required double lat, required double lng}) {
    String id = (markers.length + 1).toString();
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        draggable: true,
        onDragEnd: (argument) {
          latLngPoint[int.parse(id) - 1] = [argument.latitude, argument.longitude];
          generateLines();
        },
        infoWindow: InfoWindow(
          title: 'Position $id',
          snippet: '$lat, $lng',
          onTap: () {
            deleteMarker(MarkerId(id));
          },
        ),
      ),
    );

    latLngPoint.add([lat, lng]);
    update();
  }

  void deleteMarker(MarkerId markerId) {
    markers.removeWhere((marker) => marker.markerId == markerId);
    latLngPoint.removeAt(int.parse(markerId.value) - 1);
    if (markers.length > 1) {
      generateLines();
    } else {
      polylines.clear();
    }
    update();
  }

  void deleteAllMarker() {
    markers.clear();
    latLngPoint.clear();
    polylines.clear();
    distanceLines.clear();
    update();
  }

  Future<void> gotoCurrentLocation() async {
    final GoogleMapController controller = await controllerGoogleMap.future;
    await getUserCurrentLocation().then((value) {
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

// ! ---------------------------------------------GENERATE LINES---------------------------------------------
  Future<void> getPolyPoints({
    required String idLine,
    required int colorId,
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

    polylines.add(
      Polyline(
        polylineId: PolylineId(idLine),
        color: Constants.colors[colorId],
        points: polylineCoordinates,
        width: 4,
        consumeTapEvents: true,
      ),
    );
  }

  Future<void> generateLines() async {
    polylines.clear();
    distanceLines.clear();

    for (var i = 0; i < latLngPoint.length - 1; i++) {
      // ! GENERATE DISTANCE
      int distance = distanceTwoPoint(
        latLngPoint[i][0],
        latLngPoint[i][1],
        latLngPoint[i + 1][0],
        latLngPoint[i + 1][1],
      );

      distanceLines.add({
        'id': i.toString(),
        'color': Constants.colors[i],
        'distance': distance,
      });

      // ! GENERATE LINE
      await getPolyPoints(
        idLine: i.toString(),
        colorId: i,
        lat1: latLngPoint[i][0],
        lng1: latLngPoint[i][1],
        lat2: latLngPoint[i + 1][0],
        lng2: latLngPoint[i + 1][1],
      );
    }

    update();
  }

  int distanceTwoPoint(double lat1, double lng1, double lat2, double lng2) {
    double distance = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return distance.toInt();
  }

  void updatePoliline(PolylineId polylineId) {
    // polylines.removeWhere((element) => element. == polylineId);
    Polyline line = polylines.firstWhere((element) => element.polylineId == polylineId);
    // polylines
    // update();
  }
// ! ---------------------------------------------GENERATE LINES END---------------------------------------------

  void disableLine(PolylineId polylineId) {
    polylines.firstWhere((element) => element.polylineId == polylineId).copyWith(visibleParam: false);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserCurrentLocation().then((value) {
      initialGoogleMap = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 18,
      );
      addLocationMarker(lat: value.latitude, lng: value.longitude);
    });
    isLoading = true;
    update();
  }
}
