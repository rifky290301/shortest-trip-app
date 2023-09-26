// // To parse this JSON data, do
// //
// //     final distanceMatriksModel = distanceMatriksModelFromJson(jsonString);

// import 'dart:convert';

// DistanceMatriksModel distanceMatriksModelFromJson(String str) => DistanceMatriksModel.fromJson(json.decode(str));

// String distanceMatriksModelToJson(DistanceMatriksModel data) => json.encode(data.toJson());

// class DistanceMatriksModel {
//   final List<String>? destinationAddresses;
//   final List<String>? originAddresses;
//   final List<Row>? rows;
//   final Status? status;

//   DistanceMatriksModel({
//     this.destinationAddresses,
//     this.originAddresses,
//     this.rows,
//     this.status,
//   });

//   DistanceMatriksModel copyWith({
//     List<String>? destinationAddresses,
//     List<String>? originAddresses,
//     List<Row>? rows,
//     Status? status,
//   }) =>
//       DistanceMatriksModel(
//         destinationAddresses: destinationAddresses ?? this.destinationAddresses,
//         originAddresses: originAddresses ?? this.originAddresses,
//         rows: rows ?? this.rows,
//         status: status ?? this.status,
//       );

//   factory DistanceMatriksModel.fromJson(Map<String, dynamic> json) => DistanceMatriksModel(
//         destinationAddresses: json["destination_addresses"] == null ? [] : List<String>.from(json["destination_addresses"]!.map((x) => x)),
//         originAddresses: json["origin_addresses"] == null ? [] : List<String>.from(json["origin_addresses"]!.map((x) => x)),
//         rows: json["rows"] == null ? [] : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x))),
//         status: statusValues.map[json["status"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "destination_addresses": destinationAddresses == null ? [] : List<dynamic>.from(destinationAddresses!.map((x) => x)),
//         "origin_addresses": originAddresses == null ? [] : List<dynamic>.from(originAddresses!.map((x) => x)),
//         "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
//         "status": statusValues.reverse[status],
//       };
// }

// class Row {
//   final List<Element>? elements;

//   Row({
//     this.elements,
//   });

//   Row copyWith({
//     List<Element>? elements,
//   }) =>
//       Row(
//         elements: elements ?? this.elements,
//       );

//   factory Row.fromJson(Map<String, dynamic> json) => Row(
//         elements: json["elements"] == null ? [] : List<Element>.from(json["elements"]!.map((x) => Element.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
//       };
// }

// class Element {
//   final Distance? distance;
//   final Distance? duration;
//   final Status? status;

//   Element({
//     this.distance,
//     this.duration,
//     this.status,
//   });

//   Element copyWith({
//     Distance? distance,
//     Distance? duration,
//     Status? status,
//   }) =>
//       Element(
//         distance: distance ?? this.distance,
//         duration: duration ?? this.duration,
//         status: status ?? this.status,
//       );

//   factory Element.fromJson(Map<String, dynamic> json) => Element(
//         distance: json["distance"] == null ? null : Distance.fromJson(json["distance"]),
//         duration: json["duration"] == null ? null : Distance.fromJson(json["duration"]),
//         status: statusValues.map[json["status"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "distance": distance?.toJson(),
//         "duration": duration?.toJson(),
//         "status": statusValues.reverse[status],
//       };
// }

// class Distance {
//   final String? text;
//   final int? value;

//   Distance({
//     this.text,
//     this.value,
//   });

//   Distance copyWith({
//     String? text,
//     int? value,
//   }) =>
//       Distance(
//         text: text ?? this.text,
//         value: value ?? this.value,
//       );

//   factory Distance.fromJson(Map<String, dynamic> json) => Distance(
//         text: json["text"],
//         value: json["value"],
//       );

//   Map<String, dynamic> toJson() => {
//         "text": text,
//         "value": value,
//       };
// }

// enum Status { OK }

// final statusValues = EnumValues({"OK": Status.OK});

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final distanceMatriksModel = distanceMatriksModelFromJson(jsonString);

import 'dart:convert';

DistanceMatriksModel distanceMatriksModelFromJson(String str) => DistanceMatriksModel.fromJson(json.decode(str));

String distanceMatriksModelToJson(DistanceMatriksModel data) => json.encode(data.toJson());

class DistanceMatriksModel {
  final List<Row>? rows;

  DistanceMatriksModel({
    this.rows,
  });

  DistanceMatriksModel copyWith({
    List<Row>? rows,
  }) =>
      DistanceMatriksModel(
        rows: rows ?? this.rows,
      );

  factory DistanceMatriksModel.fromJson(Map<String, dynamic> json) => DistanceMatriksModel(
        rows: json["rows"] == null ? [] : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rows": rows == null ? [] : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class Row {
  final List<Element>? elements;

  Row({
    this.elements,
  });

  Row copyWith({
    List<Element>? elements,
  }) =>
      Row(
        elements: elements ?? this.elements,
      );

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        elements: json["elements"] == null ? [] : List<Element>.from(json["elements"]!.map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": elements == null ? [] : List<dynamic>.from(elements!.map((x) => x.toJson())),
      };
}

class Element {
  final Distance? distance;

  Element({
    this.distance,
  });

  Element copyWith({
    Distance? distance,
  }) =>
      Element(
        distance: distance ?? this.distance,
      );

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        distance: json["distance"] == null ? null : Distance.fromJson(json["distance"]),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance?.toJson(),
      };
}

class Distance {
  final int? value;

  Distance({
    this.value,
  });

  Distance copyWith({
    int? value,
  }) =>
      Distance(
        value: value ?? this.value,
      );

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
