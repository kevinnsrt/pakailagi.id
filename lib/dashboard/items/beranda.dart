import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';

class ItemBeranda extends StatefulWidget {
  final bool isRandom;

  const ItemBeranda({super.key, this.isRandom = false});

  @override
  State<ItemBeranda> createState() => _ItemBerandaState();
}

class _ItemBerandaState extends State<ItemBeranda> {
  final String apiUrl = "https://pakailagi.user.cloudjkt02.com/api/products";

  // Gunakan variabel Future agar request hanya dijalankan sekali saat initState
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Inisialisasi future di sini
    _productsFuture = fetchProducts();
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

        // Logika Randomize: Hanya acak jika isRandom true
        if (widget.isRandom) {
          products.shuffle();
        }

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
      // Gunakan variabel referensi, jangan panggil fungsi langsung di sini
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Gagal memuat data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Produk kosong"));
        }

        final products = snapshot.data!;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Container(
              width: 154,
              margin: const EdgeInsets.only(right: 14),
              child: Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        product['image_path'],
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "IDR ${product['price']}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800,
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}