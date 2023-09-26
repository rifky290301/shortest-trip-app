import 'dart:convert';

MatriksModel matriksModelFromJson(String str) => MatriksModel.fromJson(json.decode(str));

String matriksModelToJson(MatriksModel data) => json.encode(data.toJson());

class MatriksModel {
  final List<List<int>>? matriks;

  MatriksModel({
    this.matriks,
  });

  MatriksModel copyWith({
    List<List<int>>? matriks,
  }) =>
      MatriksModel(
        matriks: matriks ?? this.matriks,
      );

  factory MatriksModel.fromJson(Map<String, dynamic> json) => MatriksModel(
        matriks: json["matriks"] == null ? [] : List<List<int>>.from(json["matriks"]!.map((x) => List<int>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "matriks": matriks == null ? [] : List<dynamic>.from(matriks!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
