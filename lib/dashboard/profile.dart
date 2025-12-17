import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/about_page.dart';
import 'package:tubes_pm/edit_password/edit_password.dart';
import 'package:tubes_pm/edit_profile/edit_profile.dart';
import 'package:tubes_pm/faq/FaqPage.dart';
import 'package:tubes_pm/map/edit_location.dart';
import 'package:tubes_pm/widget/top_notif.dart';
import 'package:tubes_pm/wishlist/wishlist.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? address;
  String? url_picture;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> _signOut() async {
    // Tambahkan dialog konfirmasi agar user tidak sengaja logout
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }
  }

  void _launchWhatsApp() async {
    String phoneNumber = "6282272953096"; // Gunakan kode negara, tanpa tanda '+'
    String message = "Halo King, Saya butuh bantuan terkait aplikasi PakaiLagi.id .";

    // Format URL untuk WhatsApp
    var whatsappUrl = Uri.parse("whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
    var fallbackUrl = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        // Jika aplikasi WA tidak terinstall, buka di browser (wa.me)
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      TopNotif.error(context, "Tidak dapat membuka WhatsApp");
    }
  }

  Future<void> userdata() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await UserToken().getToken();
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"uid": user.uid}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userMap = data is List ? data[0] : data;

        final double lat = (userMap["latitude"] as num?)?.toDouble() ?? 0.0;
        final double lng = (userMap["longitude"] as num?)?.toDouble() ?? 0.0;

        String alamat = "Alamat belum diatur";
        if (lat != 0.0 && lng != 0.0) {
          alamat = await getAddressFromLatLng(lat, lng);
        }

        if (!mounted) return;
        setState(() {
          userData = userMap;
          address = alamat;
          url_picture = userMap["profile_picture"];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final url = Uri.parse("https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json");
      final response = await http.get(url, headers: {"User-Agent": "Flutter-App"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["display_name"] ?? "Alamat ditemukan";
      }
    } catch (_) {}
    return "Gagal mendapatkan alamat";
  }

  Future<void> refreshData() async => await userdata();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Akun Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildMenuSection("Pengaturan", [
                _buildMenuItem(Icons.lock_outline, "Edit Kata Sandi", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPassword()));
                }),
                _buildMenuItem(Icons.location_on_outlined, "Lokasi Anda", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditLocation(
                    lat: userData?["latitude"] ?? 0.0,
                    lng: userData?["longitude"] ?? 0.0,
                    address: address ?? "",
                  ))).then((val) => val == true ? refreshData() : null);
                }),
              ]),
              const SizedBox(height: 16),
              _buildMenuSection("Informasi", [
                _buildMenuItem(Icons.help_outline, "FAQ / Bantuan", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqPage()));
                }),
                _buildMenuItem(Icons.info_outline, "Tentang Aplikasi", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()), // Arahkan ke halaman baru
                  );
                }),
              ]),
              const SizedBox(height: 16),
              _buildMenuSection("Lainnya", [
                _buildMenuItem(Icons.logout, "Keluar", _signOut, isDanger: true),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.grayscale200,
                backgroundImage: url_picture != null ? NetworkImage(url_picture!) : null,
                child: url_picture == null ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: const Icon(Icons.verified, color: Colors.white, size: 16),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?["name"] ?? (isLoading ? "Memuat..." : "User"),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_pin, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address ?? "Lokasi belum diatur",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile())),
            icon: Icon(Icons.settings_outlined, color: AppColors.grayscale700),
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _actionButton(Icons.support_agent, "Bantuan", () {
            _launchWhatsApp();
          }),
          const SizedBox(width: 12),
          _actionButton(Icons.favorite_border, "Wishlist", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistPage()));
          }),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary600),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap, {bool isDanger = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDanger ? Colors.red.withOpacity(0.1) : AppColors.primary600.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isDanger ? Colors.red : AppColors.primary600, size: 20),
      ),
      title: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDanger ? Colors.red : AppColors.grayscale950)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}