// To parse this JSON data, do
//
//     final modelListPegawai = modelListPegawaiFromJson(jsonString);

import 'dart:convert';

ModelListPegawai modelListPegawaiFromJson(String str) => ModelListPegawai.fromJson(json.decode(str));

String modelListPegawaiToJson(ModelListPegawai data) => json.encode(data.toJson());

class ModelListPegawai {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListPegawai({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListPegawai.fromJson(Map<String, dynamic> json) => ModelListPegawai(
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
  String firstname;
  String lastname;
  String nohp;
  String email;

  Datum({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.nohp,
    required this.email,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    firstname: json["firstname"],
    lastname: json["lastname"],
    nohp: json["nohp"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "nohp": nohp,
    "email": email,
  };
}
