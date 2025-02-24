import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'model/model_wisata.dart';

class MapsAllPage extends StatefulWidget {
  @override
  _MapsAllPageState createState() => _MapsAllPageState();
}

class _MapsAllPageState extends State<MapsAllPage> {
  late GoogleMapController mapController;
  Future<ModelWisata>? _kampusFuture;

  @override
  void initState() {
    super.initState();
    _kampusFuture = fetchKampus();
  }

  Future<ModelWisata> fetchKampus() async {
    final response = await http.get(Uri.parse('http://192.168.43.45/wisata/getWisata.php'));

    if (response.statusCode == 200) {
      return modelWisataFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Maps'),
      ),
      body: FutureBuilder<ModelWisata>(
        future: _kampusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            Set<Marker> markers = snapshot.data!.data.map((kampus) {
              double? lat;
              double? long;
              try {
                lat = double.parse(kampus.lat);
                long = double.parse(kampus.long);
              } catch (e) {
                print('Error parsing lat/lng for kampus: ${kampus.nama}, lat: ${kampus.lat}, lng: ${kampus.long}');
                return null;
              }

              return Marker(
                markerId: MarkerId(kampus.nama),
                position: LatLng(lat!, long!),
                infoWindow: InfoWindow(
                  title: kampus.nama,
                ),
              );
            }).where((marker) => marker != null).cast<Marker>().toSet();

            return GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(-0.9145, 100.4607),
                zoom: 10,
              ),
              markers: markers,
            );
          }
        },
      ),
    );
  }
}