import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/dashboard/detail/detail.dart';
import 'package:tubes_pm/colors/colors.dart'; // Pastikan import warna Anda

class ItemBeranda extends StatefulWidget {
  final bool isRandom;

  const ItemBeranda({super.key, this.isRandom = false});

  @override
  ItemBerandaState createState() => ItemBerandaState();
}

class ItemBerandaState extends State<ItemBeranda> {
  final String apiUrl = "https://pakailagi.user.cloudjkt02.com/api/products";
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<void> handleRefresh() async {
    setState(() {
      _productsFuture = fetchProducts();
    });
    await _productsFuture;
  }

  String formatCurrency(dynamic number) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.parse(number.toString()));
  }

  Future<List<dynamic>> fetchProducts() async {
    try {
      final token = await UserToken().getToken();
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        if (widget.isRandom) products.shuffle();
        return products;
      } else {
        throw Exception('Gagal memuat produk');
      }
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: handleRefresh,
              child: const Text("Coba Lagi"),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Produk tidak ditemukan"));
        }

        final products = snapshot.data!;

        return RefreshIndicator(
          onRefresh: handleRefresh,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductItem(products[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductItem(dynamic product) {
    // Penyesuaian pengecekan Sold Out agar sama dengan AllItemsPage
    bool soldOut = product['status'] == 'Sold Out';

    return GestureDetector(
      onTap: soldOut
          ? null
          : () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(product_id: product['id'].toString()),
        ),
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ============================
            /// IMAGE SECTION (Sama dengan AllItemsPage)
            /// ============================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product['image_path'],
                    width: double.infinity,
                    height: 140, // Height sedikit lebih kecil untuk beranda
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                if (soldOut)
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Overlay Gelap
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "SOLD OUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),

            /// ============================
            /// INFO SECTION
            /// ============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    product['name'] ?? 'Produk Tanpa Nama',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: soldOut ? Colors.grey : AppColors.grayscale900,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Text(
                    formatCurrency(product['price']),
                    style: TextStyle(
                      color: soldOut ? Colors.grey : AppColors.primary500,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}