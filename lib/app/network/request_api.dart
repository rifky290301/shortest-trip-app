import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:skrispsi_app/app/constants.dart';
import 'package:skrispsi_app/app/models/cih_model.dart';
import 'package:skrispsi_app/app/models/distance_matriks.dart';
import 'package:skrispsi_app/app/models/matriks_model.dart';

const String baseApi = 'https://web-server-rifky.muhammad-haidar.my.id/';
const String generateMatrix = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=';

final dio = Dio();

Future<CihModel?> requestApiCih(List<List<int>> distMatrix) async {
  try {
    var res = await dio.post('${baseApi}data', data: {'data': distMatrix});
    var cihModel = CihModel.fromJson(res.data);
    return cihModel;
  } catch (e) {
    inspect(e);
    return null;
  }
}

Future<MatriksModel?> convertMatrix(List<List<double>> latLanMatrix) async {
  String tempLatLan = '';
  for (var i = 0; i < latLanMatrix.length; i++) {
    if (i + 1 != latLanMatrix.length) {
      tempLatLan = '$tempLatLan${latLanMatrix[i][0]},${latLanMatrix[i][1]}|';
    } else {
      tempLatLan = '$tempLatLan${latLanMatrix[i][0]},${latLanMatrix[i][1]}';
    }
  }

  tempLatLan = '$tempLatLan&destinations=$tempLatLan&key=${Constants.apiKey}';
  try {
    String generateMatrix = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$tempLatLan';

    print(generateMatrix);

    var resMatrix = await dio.get(generateMatrix);
    var distanceMatriksModel = DistanceMatriksModel.fromJson(resMatrix.data);

    var res = await dio.post('${baseApi}convert-matrix', data: distanceMatriksModel.toJson());
    var matriksModel = MatriksModel.fromJson(res.data);

    return matriksModel;
  } catch (e) {
    inspect(e);
    return null;
  }
}
