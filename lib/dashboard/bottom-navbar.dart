import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/history/history.dart';
import 'package:tubes_pm/dashboard/home2.dart';
import 'package:tubes_pm/dashboard/profile.dart';
import 'package:tubes_pm/dashboard/shop.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({super.key, this.selectedIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List halaman yang akan ditampilkan
  final List<Widget> _screen = [
    const HomePage2(),
    const ProfilePage(),
    const ShopPage(),
    const HistoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    _setupFCM();
    // Mengambil index awal dari parameter widget jika ada (misal dari halaman beli/checkout)
    _selectedIndex = widget.selectedIndex;
  }

  // Setup Firebase Cloud Messaging
  Future<void> _setupFCM() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance
        .subscribeToTopic('all_users')
        .then((_) => print('Subscribed OK'))
        .catchError((e) => print(e));
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screen,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, "Home"),
            _buildNavItem(2, Icons.shopping_bag_rounded, "Shop"),
            _buildNavItem(3, Icons.list, "History"),
            _buildNavItem(1, Icons.person, "Profile"),
          ],
        ),
      ),
    );
  }

  /// Fungsi Helper untuk membuat Item Navigasi
  Widget _buildNavItem(int index, IconData icon, String label) {
    // Logika penentuan warna aktif
    bool isActive = _selectedIndex == index;
    Color activeColor = AppColors.primary600; // Warna saat dipilih
    Color inactiveColor = AppColors.grayscale500; // Warna saat tidak dipilih

    return GestureDetector(
      onTap: () async {
        // Logika khusus untuk tab Shop jika diperlukan token
        if (index == 2) {
          await UserToken().getToken();
        }
        _onTapped(index);
      },
      behavior: HitTestBehavior.opaque, // Agar area klik lebih luas
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}