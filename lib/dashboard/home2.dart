import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_pm/api/user-data.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/beranda.dart';
import 'package:http/http.dart' as http;


class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String? address;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    userdata();
  }

  // ambil data user
  Future<void> userdata() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final data = await ApiServiceLogin.loginWithUid(uid: user.uid);
      userData = data;
      setState(() {});

      double lat = data["latitude"];
      double lng = data["longitude"];

      address = await getAddressFromLatLng(lat, lng);
      setState(() {});
    }
  }
  // reverse geocoding dari koordinat ke alamat
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1",
    );

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
    } else {
      return "Gagal mendapatkan alamat";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            height: 120,
            color: AppColors.primary500,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Logo
                Image.asset('assets/logo_home.png', width: 120),

                const SizedBox(width: 15),

                // === EXPANDED AGAR TIDAK OVERFLOW ===
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Lokasi
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: AppColors.grayscale700),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address ?? "Loading...",
                                  style: TextStyle(
                                      color: AppColors.grayscale700,
                                      fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      const Icon(Icons.notifications, color: Colors.white),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite_border, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 122,
                  child: Image.asset(
                    'assets/beranda_banner.png',
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                // Rekomendasi Produk
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rekomendasi Produk",
                        style: TextStyle(
                            color: AppColors.primary800,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          color: AppColors.grayscale400),
                    ],
                  ),
                ),

                SizedBox(
                  height: 238,
                  child: ItemBeranda(),
                ),

                // Produk Terbaru
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Produk Terbaru",
                        style: TextStyle(
                            color: AppColors.primary800,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          color: AppColors.grayscale400),
                    ],
                  ),
                ),

                SizedBox(
                  height: 238,
                  child: ItemBeranda(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
