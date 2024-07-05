// To parse this JSON data, do
//
//     final modelUpdateWisata = modelUpdateWisataFromJson(jsonString);

import 'dart:convert';

ModelUpdateWisata modelUpdateWisataFromJson(String str) => ModelUpdateWisata.fromJson(json.decode(str));

String modelUpdateWisataToJson(ModelUpdateWisata data) => json.encode(data.toJson());

class ModelUpdateWisata {
  bool isSuccess;
  int value;
  String message;

  ModelUpdateWisata({
    required this.isSuccess,
    required this.value,
    required this.message,
  });

  factory ModelUpdateWisata.fromJson(Map<String, dynamic> json) => ModelUpdateWisata(
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
