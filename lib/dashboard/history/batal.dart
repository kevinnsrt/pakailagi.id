import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;

class BatalPage extends StatefulWidget {
  const BatalPage({super.key});

  @override
  State<BatalPage> createState() => BatalPageState();
}

class BatalPageState extends State<BatalPage> {
  List<dynamic>? items;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }
  Future<void> refresh() async {
    await fetchItems();
  }

  Future<void> fetchItems() async {
    final result = await GetUserCart().getusercart();
    if (!mounted) return;

    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Cek loading status
    if (items == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Filter items hanya yang berstatus 'Selesai'
    final cartItems = items!.where((item) => item['status'] == 'Dibatalkan').toList();

    // 3. Tampilan jika kosong
    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: fetchItems,
          child: ListView(
            children: const [
              SizedBox(height: 100),
              Center(child: Text("Tidak ada transaksi yang dibatalkan")),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            final product = item['product'];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  /// --- STATUS HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// --- ITEM ROW ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Bagian Gambar dengan Loading & Error Builder
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product['image_path'],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey[100],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image,
                                  size: 30, color: Colors.grey),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Bagian Info Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? "No Name",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ukuran: ${product['ukuran'] ?? "-"}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "IDR ${product['price']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.primary600,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}