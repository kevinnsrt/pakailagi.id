import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/colors/colors.dart';

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

  String formatCurrency(dynamic number) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.parse(number.toString()));
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
    if (items == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cartItems = items!.where((item) => item['status'] == 'Dibatalkan').toList();

    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: RefreshIndicator(
          onRefresh: fetchItems,
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Icon(Icons.cancel_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Tidak ada transaksi yang dibatalkan",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            final product = item['product'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- STATUS HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, size: 16, color: Colors.red),
                          const SizedBox(width: 6),
                          const Text(
                            "Pesanan Dibatalkan",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "#TRX-${item['id']}",
                        style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  /// --- ITEM ROW ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product['image_path'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80, height: 80, color: Colors.grey[100],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? "No Name",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ukuran: ${product['ukuran'] ?? "-"}",
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Nilai Transaksi:",
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                                Text(
                                  formatCurrency(product['price']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.grayscale500,
                                    decoration: TextDecoration.lineThrough, // Mencoret harga karena batal
                                  ),
                                ),
                              ],
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