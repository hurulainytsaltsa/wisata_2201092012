// To parse this JSON data, do
//
//     final modelDeletePegawai = modelDeletePegawaiFromJson(jsonString);

import 'dart:convert';

ModelDeletePegawai modelDeletePegawaiFromJson(String str) => ModelDeletePegawai.fromJson(json.decode(str));

String modelDeletePegawaiToJson(ModelDeletePegawai data) => json.encode(data.toJson());

class ModelDeletePegawai {
  bool isSuccess;
  int value;
  String message;

  ModelDeletePegawai({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelDeletePegawai.fromJson(Map<String, dynamic> json) => ModelDeletePegawai(
    isSuccess: json["is_success"],
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "value": value,
    "message": message,
  };
}
