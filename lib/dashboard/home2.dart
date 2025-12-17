import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/beranda.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
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
            height: 100,
            color: AppColors.primary500,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset('assets/logo_home.png', width: 120),
                const SizedBox(width: 15),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.notifications, color: Colors.white),
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
              padding: const EdgeInsets.all(0),
              children: [
                // ============================
                // BANNER — dengan whitespace kiri kanan
                // ============================
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
                    child: Image.asset(
                      'assets/beranda_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ============================
                // REKOMENDASI PRODUK
                // ============================
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
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          size: 18, color: AppColors.grayscale400),
                    ],
                  ),
                ),

                SizedBox(height: 238, child: ItemBeranda()),

                // ============================
                // PRODUK TERBARU
                // ============================
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
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          size: 18, color: AppColors.grayscale400),
                    ],
                  ),
                ),

                SizedBox(height: 238, child: ItemBeranda()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
