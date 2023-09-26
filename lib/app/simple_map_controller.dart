import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skrispsi_app/app/models/cih_model.dart';
import 'package:skrispsi_app/app/network/request_api.dart';

import 'constants.dart';
import 'models/matriks_model.dart';

class SimpleMapController extends GetxController {
  final Completer<GoogleMapController> controllerGoogleMap = Completer();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  // MathCalculate mathCalculate = MathCalculate();
  PolylinePoints polylinePoints = PolylinePoints();
  // CIH cih = CIH();
  Constants constants = Constants();

  late CameraPosition initialGoogleMap;
  bool isLoading = false;
  bool isPopUp = false;
  List<Marker> markers = [];
  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
  List<List<double>> latLngPoint = [];
  List<Map<String, dynamic>> distanceLines = [];
  List<List<int>> matriks = [];
  String? distance;

  List<Polyline> get polylinesList => polylines.toList();

  Future<void> matrixDistance() async {
    // List<List<double>> matriksTemp = [];

    MatriksModel res = await convertMatrix(latLngPoint) ?? MatriksModel();
    matriks = res.matriks ?? [];

    // for (int i = 0; i < latLngPoint.length; i++) {
    //   List<double> temp = [];
    //   for (int j = 0; j < latLngPoint.length; j++) {
    //     await mathCalculate
    //         .calculateDistanceTwoPoint(
    //           lat1: latLngPoint[i][0],
    //           lng1: latLngPoint[i][1],
    //           lat2: latLngPoint[j][0],
    //           lng2: latLngPoint[j][1],
    //           polylinePoints: polylinePoints,
    //         )
    //         .then((value) => temp.add(value.toDouble()));
    //   }
    //   matriksTemp.add(temp);
    // }
    // matriks.addAll(matriksTemp);

    // for (int i = 0; i < matriksTemp.length; i++) {
    //   for (int j = 0; j < matriksTemp.length; j++) {
    //     matriks[i][j] = matriksTemp[j][i];
    //   }
    // }
  }

  void addLocationMarker({required double lat, required double lng}) {
    String id = (markers.length).toString();
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        draggable: true,
        onDragEnd: (argument) async {
          latLngPoint[int.parse(id) - 1] = [argument.latitude, argument.longitude];
          await generateLines();
        },
        infoWindow: InfoWindow(
          title: 'Position ${int.parse(id) + 1}',
          onTap: () {
            deleteMarker(MarkerId(id));
          },
        ),
      ),
    );

    latLngPoint.add([lat, lng]);
    update();
  }

// ! ---------------------------------------------GENERATE LINES---------------------------------------------
  Future<void> drawPolyPoints({
    required String idLine,
    required int colorId,
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
    required Color colorLine,
  }) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.apiKey,
      PointLatLng(lat1, lng1),
      PointLatLng(lat2, lng2),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    polylines.add(
      Polyline(
        polylineId: PolylineId(idLine),
        color: colorLine,
        points: polylineCoordinates,
        width: 8,
        consumeTapEvents: true,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        onTap: () {
          // print('tap');
          highlightLine(PolylineId(idLine));

          // const Tooltip(
          //   message: 'I am a Tooltip',
          //   child: Text('Hover over the text to show a tooltip.'),
          // );
        },
        // zIndex: colorId,
      ),
    );
  }

  void highlightLine(PolylineId polylineId) {
    List<Polyline> temp = polylines.toList();
    for (var i = 0; i < temp.length; i++) {
      if (temp[i].polylineId == polylineId) {
        temp[i] = temp[i].copyWith(
          colorParam: temp[i].color.withOpacity(1),
          widthParam: 12,
          zIndexParam: 999,
        );
      } else {
        temp[i] = temp[i].copyWith(
          colorParam: temp[i].color.withOpacity(0.7),
          widthParam: 8,
          zIndexParam: 1,
        );
      }
    }
    polylines = temp.toSet();
    update();
  }

  Future<void> generateLines() async {
    polylines.clear();
    distanceLines.clear();

    await matrixDistance();
    // printMatriks();

    CihModel res = await requestApiCih(matriks) ?? CihModel();

    List<int> tour = res.tour ?? [];

    // List<int> tour = cih.cheapestInsertion(distMatrix: matriks, start: 0);

    print('tour : $tour');
    print('distance : ${res.total}');
    print('tour.length : ${tour.length}');

    for (var i = 0; i < tour.length; i++) {
      Color colorLine = Constants.listColor[i];

      int from = tour[i];
      int to = tour[(i + 1) % tour.length];

      distanceLines.add({
        'id': i.toString(),
        'color': colorLine,
        'route': [from, to],
        'distance': matriks[from][to],
      });

      if (i == tour.length - 1) {
        await drawPolyPoints(
          idLine: i.toString(),
          colorId: i,
          lat1: latLngPoint[0][0],
          lng1: latLngPoint[0][1],
          lat2: latLngPoint[tour[i]][0],
          lng2: latLngPoint[tour[i]][1],
          colorLine: colorLine,
        );
      } else {
        await drawPolyPoints(
          idLine: i.toString(),
          colorId: i,
          lat1: latLngPoint[tour[i]][0],
          lng1: latLngPoint[tour[i]][1],
          lat2: latLngPoint[tour[i + 1]][0],
          lng2: latLngPoint[tour[i + 1]][1],
          colorLine: colorLine,
        );
      }
    }

    update();
  }

  void printMatriks() {
    for (var i = 0; i < matriks.length; i++) {
      print(matriks[i]);
    }
  }

  void changeVisiblePolyline(PolylineId polylineId) {
    bool line = polylines.firstWhere((element) => element.polylineId == polylineId).visible;
    List<Polyline> temp = polylines.toList();

    for (var i = 0; i < temp.length; i++) {
      if (temp[i].polylineId == polylineId) {
        temp[i] = temp[i].copyWith(visibleParam: !line);
        break;
      }
    }
    polylines = temp.toSet();
    update();
  }

  void onlyVisiblePolyline(PolylineId polylineId) {
    List<Polyline> temp = polylines.toList();
    for (var i = 0; i < temp.length; i++) {
      if (temp[i].polylineId == polylineId) {
        temp[i] = temp[i].copyWith(visibleParam: true);
      } else {
        temp[i] = temp[i].copyWith(visibleParam: false);
      }
    }
    polylines = temp.toSet();
    update();
  }
// ! ---------------------------------------------GENERATE LINES END---------------------------------------------

  Future<void> deleteMarker(MarkerId markerId) async {
    markers.removeWhere((marker) => marker.markerId == markerId);
    latLngPoint.removeAt(int.parse(markerId.value) - 1);
    if (markers.length > 1) {
      await generateLines();
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
    matriks.clear();
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

  Future showTraffic() async {
    final GoogleMapController controller = await controllerGoogleMap.future;
    controller.setMapStyle('[{"featureType": "all","stylers": [{"visibility": "off"}]}]');
    controller.setMapStyle('[{"featureType": "all","stylers": [{"visibility": "on"}]}]');
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
