// To parse this JSON data, do
//
//     final modelAddWisata = modelAddWisataFromJson(jsonString);

import 'dart:convert';

ModelAddWisata modelAddWisataFromJson(String str) => ModelAddWisata.fromJson(json.decode(str));

String modelAddWisataToJson(ModelAddWisata data) => json.encode(data.toJson());

class ModelAddWisata {
  int value;
  String message;

  ModelAddWisata({
    required this.value,
    required this.message,
  });

  factory ModelAddWisata.fromJson(Map<String, dynamic> json) => ModelAddWisata(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
