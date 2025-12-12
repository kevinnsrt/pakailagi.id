import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tubes_pm/api/post_location.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/map/map.dart';

class EditLocation extends StatefulWidget {
  final double lat;
  final double lng;
  final String address;

  const EditLocation({
    super.key,
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  late double currentLat;
  late double currentLng;
  late String currentAddress;

  @override
  void initState() {
    super.initState();
    currentLat = widget.lat;
    currentLng = widget.lng;
    currentAddress = widget.address;
  }

  Future<String> reverseGeocode(double lat, double lng) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1");

    final response = await http.get(
      url,
      headers: {
        "User-Agent": "Flutter-App",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["address"] == null) return "Alamat tidak ditemukan";

      final adr = data["address"];

      return [
        adr["road"],
        adr["suburb"],
        adr["city"],
        adr["state"],
        adr["country"],
      ].where((e) => e != null).join(", ");
    }

    return "Gagal mendapatkan alamat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Lokasi Anda")),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [

            // MAP
            Container(
              height: 200,
              width: double.infinity,
              child: MapPage(
                lat: currentLat,
                lng: currentLng,
              ),
            ),

            // ADDRESS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                currentAddress,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            // BUTTON
            SizedBox(
              width: 362,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary700,
                  elevation: 6
                ),
                onPressed: () async {
                  try {
                    bool serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("GPS tidak aktif")));
                      return;
                    }

                    LocationPermission permission =
                    await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Izin lokasi ditolak")));
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          Text("Izin lokasi permanen ditolak oleh pengguna")));
                      return;
                    }

                    final pos = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);

                    // GEOCODING
                    final newAddress =
                    await reverseGeocode(pos.latitude, pos.longitude);

                    setState(() {
                      currentLat = pos.latitude;
                      currentLng = pos.longitude;
                      currentAddress = newAddress;

                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal mengambil lokasi")),
                    );
                  }
                },
                child: Text("Ambil Lokasi"),
              ),
            ),

          //   button simpan
            SizedBox(
              width: 362,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: AppColors.primary500
                ),
                onPressed: () async{
                  try {
                    final res = await PostLocation.postLocation(
                      lat: currentLat,
                      lng: currentLng,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lokasi berhasil diperbarui")),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menyimpan lokasi")),
                    );
                  }
                }, child: Text("Simpan"),)
            )
          ],
        ),
      ),
    );
  }
}
