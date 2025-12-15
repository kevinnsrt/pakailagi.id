import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';

class ProsesCart extends StatefulWidget {
  const ProsesCart({super.key});

  @override
  State<ProsesCart> createState() => _ProsesCartState();
}

class _ProsesCartState extends State<ProsesCart> {
  List<dynamic>? items;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final result = await GetUserCart().prosesCart();
    if (!mounted) return;

    setState(() {
      items = result;
      selectedIds.clear();
    });
  }

  /// ============================
  /// ✔ ITEM DALAM PENGIRIMAN
  /// ============================
  List<dynamic> get pengirimanItems {
    if (items == null) return [];
    return items!
        .where((item) => item['status'] == 'Dalam Pengiriman')
        .toList();
  }

  /// ============================
  /// ✔ ITEM DIPROSES + PENGIRIMAN
  /// ============================
  List<dynamic> get cartItems {
    if (items == null) return [];
    return items!
        .where((item) =>
    item['status'] == 'Diproses' ||
        item['status'] == 'Dalam Pengiriman')
        .toList();
  }

  bool get hasDalamPengiriman => pengirimanItems.isNotEmpty;

  bool get selectAll {
    return pengirimanItems.isNotEmpty &&
        pengirimanItems.every((item) => selectedIds.contains(item['id']));
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartItems.isEmpty) {
      return const Center(child: Text("Tidak ada pesanan yang diproses"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: Column(
          children: [
            /// ============================
            /// ✔ PILIH SEMUA (HANYA PENGIRIMAN)
            /// ============================
            if (hasDalamPengiriman)
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedIds = pengirimanItems
                              .map<int>((item) => item['id'])
                              .toSet();
                        } else {
                          selectedIds.clear();
                        }
                      });
                    },
                  ),
                  const Text("Pilih Semua"),
                ],
              ),

            /// ============================
            /// ✔ LIST ITEM
            /// ============================
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['product'];
                  final isPengiriman =
                      item['status'] == 'Dalam Pengiriman';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
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
                                style:
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            /// Checkbox item (HANYA PENGIRIMAN)
                            isPengiriman
                                ? Checkbox(
                              value: selectedIds
                                  .contains(item['id']),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedIds.add(item['id']);
                                  } else {
                                    selectedIds
                                        .remove(item['id']);
                                  }
                                });
                              },
                            )
                                : const SizedBox(width: 48),

                            Image.network(
                              product['image_path'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  Text(product['ukuran'] ?? "-"),
                                  Align(
                                    alignment:
                                    Alignment.centerRight,
                                    child: Text(
                                      "IDR ${product['price']}",
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      /// ✔ FAB (HANYA PENGIRIMAN)
      /// ============================
      floatingActionButton: hasDalamPengiriman
          ? FloatingActionButton(
        onPressed: selectedIds.isEmpty
            ? null
            : () async {
          final token =
          await UserToken().getToken();

          final url = Uri.parse(
              "https://pakailagi.user.cloudjkt02.com/api/carts/selesai");

          final response = await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(
                {"id": selectedIds.toList()}),
          );

          if (response.statusCode == 200) {
            fetchItems();
          }
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.check,
          color: AppColors.primary500,
        ),
      )
          : null,
    );
  }
}
