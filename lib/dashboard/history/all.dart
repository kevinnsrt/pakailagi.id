import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;

class CartAll extends StatefulWidget {
  const CartAll({super.key});

  @override
  State<CartAll> createState() => _CartAllState();
}

class _CartAllState extends State<CartAll> {
  List<dynamic>? items;
  Set<int> selectedIds = {};

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
      selectedIds.clear();
    });
  }

  void _showDialog(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Pembayaran"),
        content: Container(
          height: 310,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Silahkan lakukan pembayaran: IDR $total"),
              Image.asset('assets/qris_test.jpg')
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // lanjut proses checkout
              List<int> idToPost = selectedIds.toList();
              final token = await UserToken().getToken();

              // session
              if (token == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Session habis, silakan login ulang")),
                );
                return;
              }

              // pengecekan item
              if (selectedIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pilih minimal 1 item")),
                );
                return;
              }

              // method
              final url = Uri.parse(
                  "https://pakailagi.user.cloudjkt02.com/api/carts/proses");

              final response = await http.post(url,
                  headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer $token",
                  },
                  body: jsonEncode({"id": idToPost}));

              if (response.statusCode == 200) {
                print("Barang berhasil di checkout");
                fetchItems();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }



  bool get selectAll {
    if (items == null) return false;

    final cartItems =
    items!.where((item) => item['status'] == 'Dikeranjang');

    return cartItems.isNotEmpty &&
        cartItems.every((item) => selectedIds.contains(item['id']));
  }


  /// ============================
  /// ✔ HITUNG TOTAL ITEM TERPILIH
  /// ============================
  int getTotal() {
    if (items == null) return 0;

    int total = 0;

    for (var item in items!) {
      if (item['status'] == 'Dikeranjang' &&
          selectedIds.contains(item['id'])) {
        final price = item['product']['price'] as num;
        total += price.toInt();
      }
    }

    return total;
  }


  @override
  Widget build(BuildContext context) {
    final cartItems =
    items!.where((item) => item['status'] == 'Dikeranjang').toList();

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
            /// Checkbox Pilih Semua
            Row(
              children: [
                Checkbox(
                  value: selectAll,
                  onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedIds = items!
                          .where((item) => item['status'] == 'Dikeranjang')
                          .map<int>((item) => item['id'])
                          .toSet();
                    } else {
                      selectedIds.clear();
                    }
                  });
                },

                ),
                const Text("Pilih Semua")
              ],
            ),

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
                            /// Checkbox Item
                            Checkbox(
                              value: selectedIds.contains(item['id']),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedIds.add(item['id']);
                                  } else {
                                    selectedIds.remove(item['id']);
                                  }
                                });
                              },
                            ),

                            /// Gambar
                            Image.network(
                              product['image_path'],
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

      /// ============================
      /// ✔ TOTAL + CHECKOUT BUTTON
      /// ============================
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Total: IDR ${getTotal()}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: selectedIds.isEmpty
                ? null
                : () {

              _showDialog(context, getTotal());
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.shopping_cart_checkout,
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}
