import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_pegawai/screen_page/page_beranda.dart';
import 'dart:convert';

import '../model/model_add_pegawai.dart';

class PageAddPegawai extends StatefulWidget {
  const PageAddPegawai({super.key});

  @override
  State<PageAddPegawai> createState() => _PageAddPegawaiState();
}

class _PageAddPegawaiState extends State<PageAddPegawai> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtNoHp = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  //validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //Proses untuk hit API
  bool isLoading = false;

  Future<ModelAddPegawai?> addPegawai() async {
    //handle error
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
        Uri.parse('http://192.168.43.45/pegawai/addPegawai.php'),
        body: {
          "firstname": txtFirstName.text,
          "lastname": txtLastName.text,
          "nohp": txtNoHp.text,
          "email": txtEmail.text,
        },
      );

      ModelAddPegawai data = modelAddPegawaiFromJson(response.body);
      //Cek kondisi
      if (data.value == 1) {
        //Kondisi ketika berhasil menambah pegawai
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );

          // Navigasi ke halaman utama setelah sukses
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageBeranda()),
          );
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Tambah Pegawai'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtFirstName,
                  decoration: InputDecoration(
                    hintText: 'Nama Depan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtLastName,
                  decoration: InputDecoration(
                    hintText: 'Nama Belakang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtNoHp,
                  decoration: InputDecoration(
                    hintText: 'No HP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  //validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                //Proses cek loading
                Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                    minWidth: 150,
                    height: 45,
                    onPressed: () {
                      //Cek validasi form ada kosong atau tidak
                      if (keyForm.currentState?.validate() == true) {
                        setState(() {
                          addPegawai();
                        });
                      }
                    },
                    child: Text('Add'),
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        width: 1,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
