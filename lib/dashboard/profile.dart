import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/edit_password/edit_password.dart';
import 'package:tubes_pm/edit_profile/edit_profile.dart';
import 'package:tubes_pm/faq/FaqPage.dart';
import 'package:tubes_pm/map/edit_location.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? address;
  String url_picture="";
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Map<String, dynamic>? userData;

  Future<void> userdata() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await UserToken().getToken();
    if (token == null) {
      print("Token null, user belum login");
      return;
    }

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "uid": user.uid,
        }),
      );

      if (response.statusCode != 200) {
        print("Backend error: ${response.body}");
        return;
      }
      final data = json.decode(response.body);
      print(data);
      if (data == null || data.isEmpty) return;

      // Ambil field user
      final userMap = data is List ? data[0] : data;

      // Latitude & longitude fallback
      double lat = (userMap["latitude"] ?? 0.0);
      double lng = (userMap["longitude"] ?? 0.0);
      String url_profile = (userMap["profile_picture"]);

      String alamat = await getAddressFromLatLng(lat, lng);

      if (!mounted) return;
      setState(() {
        userData = userMap;
        address = alamat;
        url_picture = url_profile;
      });

    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

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
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    await userdata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // =============================
              // PROFILE SECTION
              // =============================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // Avatar row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: Image.network(
                                url_picture,
                                width: 64,   // 2 * radius
                                height: 64,  // 2 * radius
                                fit: BoxFit.cover, // biar memenuhi lingkaran
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.person), // fallback kalau gambar gagal
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData?["name"] ?? "Loading...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grayscale950,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  address ?? "Loading...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));
                          },
                            child: Icon(Icons.edit, color: AppColors.grayscale700),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Buttons row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9)),
                                  backgroundColor: Colors.white,
                                  elevation: 6,
                                  foregroundColor: AppColors.primary700),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.contacts),
                                  SizedBox(width: 8),
                                  Text("Whatsapp"),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios_outlined,
                                      color: AppColors.grayscale400)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9)),
                                  backgroundColor: Colors.white,
                                  elevation: 6,
                                  foregroundColor: AppColors.primary700),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_border_outlined),
                                  SizedBox(width: 8),
                                  Flexible(
                                      child: Text("Favorit Saya",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_ios_outlined,
                                      color: AppColors.grayscale400)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _divider(),

              // =============================
              // PENGATURAN SECTION
              // =============================
              _sectionTitle("Pengaturan"),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditPassword()));
                },
                child: _menuItem(Icons.lock, "Edit Kata Sandi"),
              ),
              _line(),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      EditLocation(lat: userData!["latitude"],
                        lng: userData!["longitude"],
                        address: address.toString(),))).then((shouldRefresh){
                    if(shouldRefresh ==  true){
                      refreshData();
                    }

                  });
                },
                child: _menuItem(Icons.location_on, "Lokasi Anda"),
              ),

              _divider(),

              // =============================
              // INFORMASI
              // =============================
              _sectionTitle("Informasi"),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const FaqPage()));
                },
                child: _menuItem(Icons.question_mark, "FAQ"),
              ),
              // _line(),
              // _menuItem(Icons.chat, "Chat Bantuan"),

              _divider(),

              // =============================
              // LOGOUT
              // =============================
              _sectionTitle("Logout"),
              GestureDetector(
                onTap: _signOut,
                child: _menuItem(Icons.logout, "Logout"),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),)
      ),
    );
  }

  // =============================
  // Reusable Widgets
  // =============================

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 10,
      color: AppColors.grayscale300,
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 40, top: 12, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.grayscale950,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _menuItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grayscale400),
          SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14, color: AppColors.grayscale950))),
          Icon(Icons.arrow_forward_ios_outlined,
              color: AppColors.grayscale400, size: 18),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 1,
      color: AppColors.grayscale400,
    );
  }
}
