import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/detail/detail.dart';

class SearchPage extends StatefulWidget {
  final String value; // keyword pencarian
  final VoidCallback onBackToAll;
  const SearchPage({super.key, required this.value, required this.onBackToAll});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

  Future<void> fetchItems() async {
    final token = await UserToken().getToken();
    if (token == null) return;

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/products/search");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"keyword": widget.value}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (!mounted) return;

        result.sort((a, b) {
          if (a['status'] == 'Ready' && b['status'] != 'Ready') return -1;
          if (a['status'] != 'Ready' && b['status'] == 'Ready') return 1;
          return 0;
        });

        setState(() {
          items = result;
        });
      }
    } catch (e) {
      debugPrint("Error search: $e");
    }
  }

  bool isSoldOut(dynamic item) {
    return item['status'] == 'Sold Out';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar dihapus agar menyatu dengan search bar di parent
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Jika refresh, kembali ke tampilan awal atau fetch ulang
            await fetchItems();
          },
          child: items == null
              ? const Center(child: CircularProgressIndicator())
              : items!.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
            // Padding atas dibuat 0 atau kecil karena sudah ada jarak dari search bar parent
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: items!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.63,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = items![index];
              final soldOut = isSoldOut(item);

              return _buildProductCard(item, soldOut);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView( // Menggunakan ListView agar RefreshIndicator tetap berfungsi
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        Center(
          child: Text(
            "Hasil pencarian '${widget.value}' tidak ditemukan",
            style: TextStyle(color: AppColors.grayscale500, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic item, bool soldOut) {
    return GestureDetector(
      onTap: soldOut
          ? null
          : () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(product_id: item['id'].toString()),
        ),
      ),
      child: Container(
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    item['image_path'],
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                if (soldOut)
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['kondisi'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.grayscale900,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Size: ${item['ukuran']}",
                    style: TextStyle(
                      color: AppColors.grayscale500,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(item['price']),
                    style: TextStyle(
                      color: AppColors.primary500,
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
}