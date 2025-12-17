import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/widget/top_notif.dart';

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

  // Fungsi Helper Format Rupiah
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            const Text("Belum ada pesanan aktif", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Konsisten dengan CartAll
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: Column(
          children: [
            /// HEADER PILIH SEMUA (Hanya jika ada yang sedang dikirim)
            if (hasDalamPengiriman)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      activeColor: AppColors.primary600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                    const Text("Pilih Semua (Barang Diterima)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            /// LIST ITEM
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['product'];
                  final isPengiriman = item['status'] == 'Dalam Pengiriman';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isPengiriman ? Icons.local_shipping_outlined : Icons.inventory_2_outlined,
                                  size: 16,
                                  color: isPengiriman ? AppColors.primary600 : Colors.orange,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isPengiriman ? "Sedang Dikirim" : "Sedang Diproses",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isPengiriman ? AppColors.primary600 : Colors.orange,
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

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Checkbox (Hanya muncul jika status Dalam Pengiriman)
                            if (isPengiriman)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Checkbox(
                                  value: selectedIds.contains(item['id']),
                                  activeColor: AppColors.primary600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                              ),

                            /// Gambar Produk
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['image_path'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 70, height: 70, color: Colors.grey[100],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Ukuran: ${product['ukuran'] ?? "-"}",
                                      style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formatCurrency(product['price']),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
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

      /// BOTTOM BUTTON
      bottomNavigationBar: hasDalamPengiriman && selectedIds.isNotEmpty
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => _confirmSelesai(),
              icon: const Icon(Icons.verified_outlined, color: Colors.white),
              label: Text(
                "Konfirmasi ${selectedIds.length} Barang Diterima",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Future<void> _confirmSelesai() async {
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
      TopNotif.success(context, "Pesanan telah selesai. Terima kasih!");
      fetchItems();
    } else {
      TopNotif.error(context, "Gagal mengonfirmasi pesanan");
    }
  }
}