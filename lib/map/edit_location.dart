import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/api/post_location.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/map/map.dart';
import 'package:tubes_pm/widget/top_notif.dart';

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
  bool isGettingLocation = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    currentLat = widget.lat;
    currentLng = widget.lng;
    currentAddress = widget.address;
  }

  Future<String> reverseGeocode(double lat, double lng) async {
    try {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1");
      final response = await http.get(url, headers: {"User-Agent": "Flutter-App"});

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
    } catch (_) {}
    return "Gagal mendapatkan alamat";
  }

  Future<void> _handleGetCurrentLocation() async {
    setState(() => isGettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        TopNotif.error(context, "GPS tidak aktif. Silakan aktifkan GPS Anda.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          TopNotif.error(context, "Izin lokasi ditolak.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        TopNotif.error(context, "Izin lokasi permanen ditolak.");
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final newAddress = await reverseGeocode(pos.latitude, pos.longitude);

      setState(() {
        currentLat = pos.latitude;
        currentLng = pos.longitude;
        currentAddress = newAddress;
      });
    } catch (e) {
      TopNotif.error(context, "Gagal mengambil lokasi.");
    } finally {
      setState(() => isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Lokasi Pengiriman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          // MAP SECTION - Dibuat lebih besar dan elegan
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: MapPage(
                    lat: currentLat,
                    lng: currentLng,
                  ),
                ),
                // Overlay Gradasi atau Dekorasi Peta bisa di sini
              ],
            ),
          ),

          // INFO & BUTTON SECTION
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary600),
                    const SizedBox(width: 8),
                    const Text("Alamat Saat Ini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),

                // Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentAddress,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.primary600),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isGettingLocation ? null : _handleGetCurrentLocation,
                        icon: isGettingLocation
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.my_location, size: 18),
                        label: const Text("GPS Saya"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isSaving ? null : () async {
                          setState(() => isSaving = true);
                          try {
                            await PostLocation.postLocation(lat: currentLat, lng: currentLng);

                            // 1. Tampilkan notifikasi
                            TopNotif.success(context, "Lokasi Berhasil Diperbarui");

                            // 2. Berikan jeda sebentar agar user bisa melihat notifikasi
                            // dan menghindari tabrakan navigasi (error _debugLocked)
                            await Future.delayed(const Duration(milliseconds: 1500));

                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            if (mounted) {
                              TopNotif.error(context, "Gagal menyimpan lokasi");
                            }
                          } finally {
                            if (mounted) {
                              setState(() => isSaving = false);
                            }
                          }
                        },
                        child: isSaving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}