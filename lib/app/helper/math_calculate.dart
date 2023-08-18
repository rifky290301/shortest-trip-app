import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../constants.dart';

class MathCalculate {
  Future<int> calculateDistanceTwoPoint({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
    required PolylinePoints polylinePoints,
  }) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.apiKey,
      PointLatLng(lat1, lng1),
      PointLatLng(lat2, lng2),
    );

    int distance = 0;
    if (result.points.isNotEmpty) {
      for (var i = 0; i < result.points.length - 1; i++) {
        distance += distanceTwoPoint(
          result.points[i].latitude,
          result.points[i].longitude,
          result.points[i + 1].latitude,
          result.points[i + 1].longitude,
        );
      }
    }

    return distance.toInt();
  }

  int distanceTwoPoint(lat1, lng1, lat2, lng2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
    return (12742000 * asin(sqrt(a))).toInt();
  }
}
