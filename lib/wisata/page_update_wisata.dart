import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_pegawai/wisata/page_utama.dart';
import 'dart:convert';

import 'model/model_wisata.dart';

class UpdateWisataPage extends StatefulWidget {
  final Datum data;

  UpdateWisataPage({required this.data});

  @override
  _UpdateWisataPageState createState() => _UpdateWisataPageState();
}

class _UpdateWisataPageState extends State<UpdateWisataPage> {
  late TextEditingController _namaController;
  late TextEditingController _lokasiController;
  late TextEditingController _deskripsiController;
  late TextEditingController _latController;
  late TextEditingController _longController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data.nama);
    _lokasiController = TextEditingController(text: widget.data.lokasi);
    _deskripsiController = TextEditingController(text: widget.data.deskripsi);
    _latController = TextEditingController(text: widget.data.lat.toString());
    _longController = TextEditingController(text: widget.data.long.toString());
    _emailController = TextEditingController(text: widget.data.email);
    _phoneController = TextEditingController(text: widget.data.phone);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    _latController.dispose();
    _longController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateWisata() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'id': widget.data.id.toString(),
      'nama': _namaController.text,
      'lokasi': _lokasiController.text,
      'deskripsi': _deskripsiController.text,
      'lat': _latController.text,
      'long': _longController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.45/wisata/updateWisata.php'),
        body: data,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['value'] == 1) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PageListLatihanWisata()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        } else {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PageListLatihanWisata()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        }
      } else {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PageListLatihanWisata()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PageListLatihanWisata()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Wisata'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _lokasiController,
              decoration: InputDecoration(labelText: 'Lokasi'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _deskripsiController,
              maxLines: 2,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Latitude'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _longController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Longitude'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _updateWisata,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
