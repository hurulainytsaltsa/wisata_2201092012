import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/model_siswa.dart';
import 'model/model_delete_siswa.dart';

class SiswaListScreen extends StatefulWidget {
  @override
  _SiswaListScreenState createState() => _SiswaListScreenState();
}

class _SiswaListScreenState extends State<SiswaListScreen> {
  late ModelSiswa _modelSiswa;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.43.45/siswa/getSiswa.php'));

    if (response.statusCode == 200) {
      setState(() {
        _modelSiswa = modelSiswaFromJson(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load data';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSiswa(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.45/siswa/deleteSiswa.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      final ModelDeleteSiswa result = modelDeleteSiswaFromJson(response.body);
      if (result.isSuccess) {
        setState(() {
          _modelSiswa.data.removeWhere((siswa) => siswa.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data')));
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Yakin ingin menghapus siswa ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSiswa(id);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Siswa'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
        itemCount: _modelSiswa.data.length,
        itemBuilder: (context, index) {
          Datum siswa = _modelSiswa.data[index];
          return ListTile(
            title: Text(siswa.nama),
            subtitle: Text(siswa.sekolah),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(siswa.email),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(siswa.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
