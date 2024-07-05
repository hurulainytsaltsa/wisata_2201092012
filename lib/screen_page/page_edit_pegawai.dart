import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/model_list_pegawai.dart'; // Pastikan diimpor modelnya

class PageEditPegawai extends StatefulWidget {
  final Datum data; // Gunakan tipe data Datum
  const PageEditPegawai({Key? key, required this.data}) : super(key: key);

  @override
  State<PageEditPegawai> createState() => _PageEditPegawaiState();
}

class _PageEditPegawaiState extends State<PageEditPegawai> {
  late TextEditingController txtFirstname;
  late TextEditingController txtLastname;
  late TextEditingController txtNohp;
  late TextEditingController txtEmail;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal
    txtFirstname = TextEditingController(text: widget.data.firstname);
    txtLastname = TextEditingController(text: widget.data.lastname);
    txtNohp = TextEditingController(text: widget.data.nohp);
    txtEmail = TextEditingController(text: widget.data.email);
  }

  Future<void> updatePegawai() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.45/pegawai/editPegawai.php'),
        body: {
          'id': widget.data.id.toString(),
          'firstname': txtFirstname.text,
          'lastname': txtLastname.text,
          'nohp': txtNohp.text,
          'email': txtEmail.text,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['is_success']) {
          Navigator.pop(context, true); // Kembali ke halaman sebelumnya dengan nilai true
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengupdate data: ${jsonResponse['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghubungi server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Edit Pegawai'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: txtFirstname,
              decoration: InputDecoration(
                hintText: 'Firstname',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: txtLastname,
              decoration: InputDecoration(
                hintText: 'Lastname',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: txtNohp,
              decoration: InputDecoration(
                hintText: 'No HP',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: txtEmail,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                updatePegawai(); // Panggil fungsi untuk update data
              },
              child: const Text("SIMPAN"),
            ),
          ],
        ),
      ),
    );
  }
}
