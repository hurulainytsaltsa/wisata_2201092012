import 'package:flutter/material.dart';

class PageDetailPegawai extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String nohp;
  final String email;

  PageDetailPegawai({
    required this.firstname,
    required this.lastname,
    required this.nohp,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pegawai'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$firstname $lastname',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "No HP: $nohp\nEmail: $email",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
