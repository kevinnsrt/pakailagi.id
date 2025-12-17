import 'package:flutter/material.dart';
import 'package:tubes_pm/api/notification.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/beranda.dart';
import 'package:tubes_pm/widget/notification.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  bool _isFetching = false;

  // Fungsi untuk mengambil data dari API dan menampilkan Popup
  Future<void> _handleNotificationClick() async {
    setState(() => _isFetching = true);

    // Ambil data dari API Laravel
    final List<Map<String, dynamic>> notifications =
    await NotificationService().fetchNotifications();

    if (!mounted) return;
    setState(() => _isFetching = false);

    // Tampilkan Popup dengan data asli dari Database
    showDialog(
      context: context,
      builder: (context) => NotificationPopup(notifications: notifications),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ============================
          // HEADER
          // ============================
          Container(
            width: double.infinity,
            height: 110,
            color: AppColors.primary500,
            padding: const EdgeInsets.only(left: 20, right: 10, top: 30),
            child: Row(
              children: [
                Image.asset('assets/logo_home.png', width: 120),
                const SizedBox(width: 15),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isFetching ? null : _handleNotificationClick,
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _isFetching
                                ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2
                                )
                            )
                                : const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ============================
          // CONTENT
          // ============================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // BANNER
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 122,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset('assets/beranda_banner.png', fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 24),

                // REKOMENDASI PRODUK
                _buildSectionTitle("Rekomendasi Produk"),
                const SizedBox(height: 238, child: ItemBeranda(isRandom: true,)),

                const SizedBox(height: 16),

                // PRODUK TERBARU
                _buildSectionTitle("Produk Terbaru"),
                const SizedBox(height: 238, child: ItemBeranda(isRandom: false,)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: AppColors.primary800, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}