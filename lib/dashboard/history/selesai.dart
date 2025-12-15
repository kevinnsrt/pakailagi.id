import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;

class SelesaiPage extends StatefulWidget {
  const SelesaiPage({super.key});

  @override
  State<SelesaiPage> createState() => _SelesaiPageState();
}

class _SelesaiPageState extends State<SelesaiPage> {
  List<dynamic>? items;
  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    var result = await GetUserCart().getusercart();
    if (!mounted) return;

    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems =
    items!.where((item) => item['status'] == 'Selesai').toList();

    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items!.isEmpty) {
      return const Center(child: Text("Keranjang kosong"));
    }

    if (cartItems.isEmpty) {
      return const Center(child: Text("Keranjang kosong"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: Column(
          children: [

            /// LIST ITEM
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['product'];

                  return Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    padding: const EdgeInsets.all(10),
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
                        /// Status
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
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// ITEM ROW
                        Row(
                          children: [
                            /// Gambar
                            Image.network(
                              items![index]['product']['image_path'],
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(width: 12),

                            /// Text Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(product['ukuran'] ?? "-"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "IDR ${product['price']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
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
          ],
        ),
      ),
    );
  }
}
