// To parse this JSON data, do
//
//     final modelSiswa = modelSiswaFromJson(jsonString);

import 'dart:convert';

ModelSiswa modelSiswaFromJson(String str) => ModelSiswa.fromJson(json.decode(str));

String modelSiswaToJson(ModelSiswa data) => json.encode(data.toJson());

class ModelSiswa {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelSiswa({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelSiswa.fromJson(Map<String, dynamic> json) => ModelSiswa(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String nama;
  String sekolah;
  String email;

  Datum({
    required this.id,
    required this.nama,
    required this.sekolah,
    required this.email,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nama: json["nama"],
    sekolah: json["sekolah"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "sekolah": sekolah,
    "email": email,
  };
}
