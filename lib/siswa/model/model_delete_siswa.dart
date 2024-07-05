// To parse this JSON data, do
//
//     final modelDeleteSiswa = modelDeleteSiswaFromJson(jsonString);

import 'dart:convert';

ModelDeleteSiswa modelDeleteSiswaFromJson(String str) => ModelDeleteSiswa.fromJson(json.decode(str));

String modelDeleteSiswaToJson(ModelDeleteSiswa data) => json.encode(data.toJson());

class ModelDeleteSiswa {
  bool isSuccess;
  int value;
  String message;

  ModelDeleteSiswa({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelDeleteSiswa.fromJson(Map<String, dynamic> json) => ModelDeleteSiswa(
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
