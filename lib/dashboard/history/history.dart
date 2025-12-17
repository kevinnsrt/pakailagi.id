import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/history/all.dart';
import 'package:tubes_pm/dashboard/history/proses.dart';
import 'package:tubes_pm/dashboard/history/selesai.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final GlobalKey<CartAllState> _allKey = GlobalKey<CartAllState>();
  final GlobalKey<ProsesCartState> _prosesKey = GlobalKey<ProsesCartState>();
  final GlobalKey<SelesaiPageState> _selesaiKey = GlobalKey<SelesaiPageState>();

  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    /// AUTO REFRESH SETIAP PINDAH TAB
    if (index == 0) {
      _allKey.currentState?.refresh();
    } else if (index == 1) {
      _prosesKey.currentState?.refresh();
    } else if (index == 2) {
      _selesaiKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {

    final screens = [
      CartAll(key: _allKey),
      ProsesCart(key: _prosesKey),
      SelesaiPage(key: _selesaiKey),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Histori",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            /// ============================
            /// TAB MENU
            /// ============================
            Container(
              width: 347,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabItem("Dikeranjang", 0),
                  _tabItem("Diproses", 1),
                  _tabItem("Selesai", 2),
                  Text(
                    "Dibatalkan",
                    style: TextStyle(
                      color: AppColors.grayscale950,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ============================
            /// CONTENT
            /// ============================
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: screens,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================
  /// TAB ITEM WIDGET
  /// ============================
  Widget _tabItem(String title, int index) {
    final isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => _onTapped(index),
      child: Text(
        title,
        style: TextStyle(
          color: isActive
              ? AppColors.primary500
              : AppColors.grayscale950,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
