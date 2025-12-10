import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tubes_pm/authentication/register_auth.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/map/map.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _number = TextEditingController();

  String? _locationText = "Belum diambil";

  // ─────────────────────────────────────────────
  // FUNGSI AMBIL LOKASI
  // ─────────────────────────────────────────────
  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("GPS tidak aktif")));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Izin lokasi ditolak")));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Izin lokasi permanen ditolak")));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationText = "${pos.latitude}, ${pos.longitude}";
      });

      // Simpan ke RegisterAuth
      RegisterAuth.instance.location = _locationText!;

      print("Lokasi tersimpan: ${RegisterAuth.instance.location}");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mengambil lokasi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 358,
                      height: 104,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Image.asset('assets/register_logo.png'),
                          Text(
                            "Lengkapi Data",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary700),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Nomor Telepon
                    Container(
                      width: 362,
                      child: Column(
                        children: [
                          Column(
                            spacing: 8,
                            children: [
                              SizedBox(
                                width: 355,
                                child: Text(
                                  "Nomor Telepon",
                                  style: TextStyle(
                                      color: AppColors.grayscale800, fontSize: 12),
                                ),
                              ),
                              TextField(
                                controller: _number,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Lokasi
                          Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // tampilkan alamat rencananya
                              Text(
                                "Lokasi Anda: $_locationText",
                                style: TextStyle(fontSize: 13),
                              ),

                              // ElevatedButton(
                              //   onPressed: () {
                              //     if (_locationText == "Belum diambil") return;
                              //
                              //     final parts = _locationText!.split(", ");
                              //     final lat = double.parse(parts[0]);
                              //     final lng = double.parse(parts[1]);
                              //
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (_) => MapPage(lat: lat, lng: lng),
                              //       ),
                              //     );
                              //   },
                              //   child: Text("Lihat di Peta"),
                              // ),
                              if (_locationText != "Belum diambil") ...[
                                SizedBox(height: 12),
                                Container(
                                  height: 200, // boleh kamu sesuaikan
                                  width: double.infinity,
                                  child: MapPage(
                                    key: ValueKey(_locationText),
                                    lat: double.parse(_locationText!.split(", ")[0]),
                                    lng: double.parse(_locationText!.split(", ")[1]),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // tombol get location
                    Container(
                      width: 362,
                      height: 48,
                      child:  // Tombol ambil lokasi
                      ElevatedButton(
                        onPressed: getUserLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          foregroundColor: AppColors.primary700
                        ),
                        child: Text("Ambil Lokasi",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),

                    // Tombol lanjut
                    Container(
                      width: 362,
                      height: 48,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary600,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            RegisterAuth.instance.number = _number.text;

                            if (RegisterAuth.instance.number.isEmpty ||
                                RegisterAuth.instance.location.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Data tidak boleh kosong",
                                  style: TextStyle(
                                      color: AppColors.grayscale50,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: AppColors.primary500,
                              ));
                            } else {
                              RegisterAuth.instance.register2(context);
                            }
                          },
                          child: Text(
                            "Selanjutnya",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),

                    SizedBox(height: 28),
                  ],
                )),
          ),
        ));
  }
}
