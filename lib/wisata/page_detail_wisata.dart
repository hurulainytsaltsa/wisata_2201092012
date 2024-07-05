import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_pegawai/wisata/page_add_wisata.dart';
import 'model/model_wisata.dart';
import 'package:http/http.dart' as http;
import 'page_update_wisata.dart';
import 'page_utama.dart';

class DetailWisata extends StatelessWidget {
  final Datum data;

  DetailWisata(this.data);

  Future<void> _deleteWisata(BuildContext context) async {
    var response = await http.post(
      Uri.parse('http://192.168.43.45/wisata/deleteWisata.php'),
      body: {'id': data.id.toString()},
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
      }
      else {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.nama),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://192.168.43.45/wisata/gambar/${data.gambar}',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 16),
              Text(
                data.nama,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                data.deskripsi,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Lokasi: ${data.lokasi}'),
              Text('Latitude: ${data.lat}'),
              Text('Longitude: ${data.long}'),
              Text('Phone: ${data.phone}'),
              Text('Email: ${data.email}'),
              SizedBox(height: 16),
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(data.lat), double.parse(data.long)),
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(data.nama),
                      position: LatLng(double.parse(data.lat), double.parse(data.long)),
                      infoWindow: InfoWindow(title: data.nama),
                    ),
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PageAddWisata(),
                        ),
                      );
                    },
                    child: Text("CREATE"),
                  ),
                  SizedBox(width: 16), // Jarak antara tombol
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateWisataPage(data: data),
                        ),
                      );
                    },
                    child: Text("UPDATE"),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    child: Text("DELETE"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteWisata(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
