class Pegawai {
  final int id;
  final String firstname;
  final String lastname;
  final String nohp;
  final String email;

  Pegawai({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.nohp,
    required this.email,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      nohp: json['nohp'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'nohp': nohp,
      'email': email,
    };
  }
}
