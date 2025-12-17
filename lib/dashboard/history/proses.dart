import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';

class ProsesCart extends StatefulWidget {
  const ProsesCart({super.key});

  @override
  State<ProsesCart> createState() => ProsesCartState();
}

class ProsesCartState extends State<ProsesCart> {
  List<dynamic>? items;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> refresh() async {
    await fetchItems();
  }

  Future<void> fetchItems() async {
    final result = await GetUserCart().prosesCart();
    if (!mounted) return;

    setState(() {
      items = result;
      selectedIds.clear();
    });
  }

  List<dynamic> get pengirimanItems {
    if (items == null) return [];
    return items!.where((item) => item['status'] == 'Dalam Pengiriman').toList();
  }

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
            /// PILIH SEMUA
            if (hasDalamPengiriman)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      activeColor: AppColors.primary600,
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
                    const Text("Pilih Semua (Diterima)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            /// LIST ITEM
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['product'];
                  final isPengiriman = item['status'] == 'Dalam Pengiriman';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    padding: const EdgeInsets.all(12),
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
                        /// Status Tag
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPengiriman ? AppColors.primary600 : Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['status'],
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Checkbox (Hanya muncul jika status Dalam Pengiriman)
                            if (isPengiriman)
                              Checkbox(
                                value: selectedIds.contains(item['id']),
                                activeColor: AppColors.primary600,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIds.add(item['id']);
                                    } else {
                                      selectedIds.remove(item['id']);
                                    }
                                  });
                                },
                              )
                            else
                              const SizedBox(width: 8),

                            /// Gambar Produk
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['image_path'],
                                width: 85,
                                height: 85,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 85,
                                    height: 85,
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
                                    width: 85,
                                    height: 85,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// Detail Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Ukuran: ${product['ukuran'] ?? "-"}",
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "IDR ${product['price']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary600,
                                          fontSize: 15
                                      ),
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

      floatingActionButton: hasDalamPengiriman && selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: () async {
          final token = await UserToken().getToken();
          final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/selesai");

          final response = await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"id": selectedIds.toList()}),
          );

          if (response.statusCode == 200) {
            fetchItems();
          }
        },
        backgroundColor: AppColors.primary600,
        label: const Text("Konfirmasi Selesai", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
      )
          : null,
    );
  }
}