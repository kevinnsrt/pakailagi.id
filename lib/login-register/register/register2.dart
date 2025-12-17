import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/register_auth.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/map/map.dart';
import 'package:tubes_pm/widget/top_notif.dart';
import 'package:flutter/services.dart'; // Tambahkan ini

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _number = TextEditingController();
  bool _isGettingLocation = false;

  double? _latitude;
  double? _longitude;
  String? _addressText;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  // Fungsi untuk mengubah koordinat menjadi Nama Jalan
  Future<String> reverseGeocode(double lat, double lng) async {
    try {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1");

      // Nominatim memerlukan User-Agent agar tidak diblokir
      final response = await http.get(url, headers: {"User-Agent": "TubesPM-App"});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["address"] == null) return "Alamat tidak ditemukan";

        final adr = data["address"];
        // Menyusun komponen alamat yang tersedia
        List<String> parts = [];
        if (adr["road"] != null) parts.add(adr["road"]);
        if (adr["suburb"] != null) parts.add(adr["suburb"]);
        if (adr["city"] != null || adr["town"] != null) {
          parts.add(adr["city"] ?? adr["town"]);
        }

        return parts.isNotEmpty ? parts.join(", ") : "Lokasi Terdeteksi";
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
    return "Gagal mendapatkan detail alamat";
  }

  // Fungsi Ambil Lokasi GPS
  Future<void> getUserLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      // Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) TopNotif.error(context, "GPS tidak aktif. Mohon aktifkan GPS.");
        return;
      }

      // Cek Izin Lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) TopNotif.error(context, "Izin lokasi ditolak.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) TopNotif.error(context, "Izin lokasi permanen ditolak.");
        return;
      }

      // Ambil Posisi
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Jalankan Reverse Geocoding
      final String fullAddress = await reverseGeocode(pos.latitude, pos.longitude);

      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
        _addressText = fullAddress;
      });

      // Update Singleton RegisterAuth
      RegisterAuth.instance.latitude = pos.latitude;
      RegisterAuth.instance.longitude = pos.longitude;

    } catch (e) {
      if (mounted) TopNotif.error(context, "Terjadi kesalahan sistem lokasi.");
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // LOGO (SUDAH DIPERBAIKI LEBARNYA)
            SizedBox(
              width: 450,
              child: Image.asset(
                  'assets/register_logo.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft
              ),
            ),

            const SizedBox(height: 12),
            Text(
              "Lengkapi Data",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary700),
            ),
            const SizedBox(height: 32),

            // NOMOR TELEPON
            // NOMOR TELEPON
            const Text(
              "Nomor Telepon",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _number,
              keyboardType: TextInputType.number, // Mengubah ke number keyboard
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Hanya mengizinkan angka
                LengthLimitingTextInputFormatter(15),   // Membatasi panjang nomor (opsional)
              ],
              decoration: InputDecoration(
                hintText: "Contoh: 08123456789",
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // LOKASI SECTION
            const Text(
              "Lokasi Pengiriman",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 12),

            if (_latitude != null && _longitude != null) ...[
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MapPage(
                    lat: _latitude!,
                    lng: _longitude!,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Nama Jalan hasil Reverse Geocode
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 18, color: AppColors.primary600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _addressText ?? "Memuat alamat...",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          height: 1.4
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Text("Lokasi belum diambil", style: TextStyle(color: Colors.grey)),
                ),
              ),

            const SizedBox(height: 32),

            // ACTION BUTTONS
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGettingLocation ? null : getUserLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary700,
                  side: BorderSide(color: AppColors.primary700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: _isGettingLocation
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: const Text("Ambil Lokasi"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  String phoneNumber = _number.text.trim();

                  if (phoneNumber.isEmpty) {
                    TopNotif.error(context, "Nomor telepon tidak boleh kosong.");
                  } else if (phoneNumber.length < 11) {
                    TopNotif.error(context, "Nomor telepon minimal 11 digit.");
                  } else if (_latitude == null) {
                    TopNotif.error(context, "Harap ambil lokasi GPS Anda.");
                  } else {
                    RegisterAuth.instance.number = phoneNumber;
                    RegisterAuth.instance.register2(context);
                  }
                },
                child: const Text("Daftar Sekarang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}