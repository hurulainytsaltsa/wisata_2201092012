import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/model_wisata.dart';
import 'page_all_maps.dart';
import 'page_detail_wisata.dart';

class PageListLatihanWisata extends StatefulWidget {
  const PageListLatihanWisata({super.key});

  @override
  State<PageListLatihanWisata> createState() => _PageListLatihanWisataState();
}

class _PageListLatihanWisataState extends State<PageListLatihanWisata> {
  String? userName;
  TextEditingController searchController = TextEditingController();
  List<Datum>? wisataList;
  List<Datum>? filteredWisataList;

  //method untuk get wisata
  Future<List<Datum>?> getWisata() async {
    try {
      //berhasil
      http.Response response = await http
          .get(Uri.parse('http://192.168.43.45/wisata/getWisata.php'));

      return modelWisataFromJson(response.body).data;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Aplikasi Wisata')),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      filteredWisataList = wisataList
                          ?.where((element) =>
                      element.nama.toLowerCase().contains(value.toLowerCase()) ||
                          element.deskripsi.toLowerCase().contains(value.toLowerCase()))
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
                SizedBox(height: 15,),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MapsAllPage()));
                    },
                    child: Text("See Location"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getWisata(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.hasData) {
                  wisataList = snapshot.data;
                  if (filteredWisataList == null) {
                    filteredWisataList = wisataList;
                  }
                  return ListView.builder(
                      itemCount: filteredWisataList!.length,
                      itemBuilder: (context, index) {
                        Datum data = filteredWisataList![index];
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              //Ini untuk ke detail
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailWisata(data)));
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'http://192.168.43.45/wisata/gambar/${data.gambar}',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      data.nama,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      data.deskripsi,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
