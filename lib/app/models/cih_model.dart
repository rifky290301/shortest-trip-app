// To parse this JSON data, do
//
//     final cihModel = cihModelFromJson(jsonString);

import 'dart:convert';

CihModel cihModelFromJson(String str) => CihModel.fromJson(json.decode(str));

String cihModelToJson(CihModel data) => json.encode(data.toJson());

class CihModel {
  final double? total;
  final List<int>? tour;

  CihModel({
    this.total,
    this.tour,
  });

  CihModel copyWith({
    double? total,
    List<int>? tour,
  }) =>
      CihModel(
        total: total ?? this.total,
        tour: tour ?? this.tour,
      );

  factory CihModel.fromJson(Map<String, dynamic> json) => CihModel(
        total: json["total"]?.toDouble(),
        tour: json["tour"] == null ? [] : List<int>.from(json["tour"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "tour": tour == null ? [] : List<dynamic>.from(tour!.map((x) => x)),
      };
}
