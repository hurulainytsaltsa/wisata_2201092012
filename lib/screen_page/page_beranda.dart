import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/model_list_pegawai.dart';
import 'page_add_pegawai.dart';
import 'page_edit_pegawai.dart';
import 'page_detail_pegawai.dart';

class PageBeranda extends StatefulWidget {
  const PageBeranda({Key? key}) : super(key: key);

  @override
  _PageBerandaState createState() => _PageBerandaState();
}

class _PageBerandaState extends State<PageBeranda> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? pegawaiList;
  List<Datum>? filteredPegawaiList;

  @override
  void initState() {
    super.initState();
    getPegawai(); // Panggil fungsi untuk mengambil data pegawai saat pertama kali halaman dimuat
  }

  Future<void> getPegawai() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.43.45/pegawai/getPegawai.php'));
      if (response.statusCode == 200) {
        setState(() {
          pegawaiList = modelListPegawaiFromJson(response.body).data;
          filteredPegawaiList = pegawaiList;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data pegawai')),
        );
      }
    } catch (e) {
      print('Error getPegawai: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> deleteData(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.45/pegawai/deletePegawai.php'),
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          // Hapus data dari list lokal
          setState(() {
            pegawaiList!.removeWhere((pegawai) => pegawai.id == id);
            filteredPegawaiList!.removeWhere((pegawai) => pegawai.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pegawai berhasil dihapus')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghubungi server'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Pegawai')),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredPegawaiList = pegawaiList
                      ?.where((element) =>
                  element.firstname.toLowerCase().contains(value.toLowerCase()) ||
                      element.lastname.toLowerCase().contains(value.toLowerCase()) ||
                      element.nohp.toLowerCase().contains(value.toLowerCase()) ||
                      element.email.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredPegawaiList != null
                ? ListView.builder(
              itemCount: filteredPegawaiList!.length,
              itemBuilder: (context, index) {
                Datum data = filteredPegawaiList![index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              '${data.firstname} ${data.lastname}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "No HP: ${data.nohp}\nEmail: ${data.email}",
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    // Handle detail view
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PageDetailPegawai(
                                          firstname: data.firstname,
                                          lastname: data.lastname,
                                          nohp: data.nohp,
                                          email: data.email,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PageEditPegawai(data: data),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        // Refresh data jika ada perubahan
                                        getPegawai();
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Hapus Data'),
                                        content: Text(
                                          'Apakah Anda yakin ingin menghapus data ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteData(
                                                  data.id); // Panggil fungsi deleteData dengan id
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ya'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(child: CircularProgressIndicator(color: Colors.orange)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate ke PageAddPegawai
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageAddPegawai()),
          ).then((value) {
            if (value == true) {
              // Refresh data jika ada perubahan setelah menambahkan pegawai baru
              getPegawai();
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
