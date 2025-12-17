import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/widget/top_notif.dart';

class CartAll extends StatefulWidget {
  const CartAll({super.key});

  @override
  State<CartAll> createState() => CartAllState();
}

class CartAllState extends State<CartAll> {
  List<dynamic>? items;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // Helper Format Rupiah
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
      selectedIds.clear();
    });
  }

  int getTotal() {
    if (items == null) return 0;
    int total = 0;
    for (var item in items!) {
      if (item['status'] == 'Dikeranjang' && selectedIds.contains(item['id'])) {
        total += (item['product']['price'] as num).toInt();
      }
    }
    return total;
  }

  bool get selectAll {
    if (items == null) return false;
    final cartItems = items!.where((item) => item['status'] == 'Dikeranjang');
    return cartItems.isNotEmpty && cartItems.every((item) => selectedIds.contains(item['id']));
  }

  Future<void> deleteCartItem(int id) async {
    final token = await UserToken().getToken();
    if (token == null) return;
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/delete/$id");
    final response = await http.delete(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 200) throw Exception("Gagal");
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) return const Center(child: CircularProgressIndicator());
    final cartItems = items!.where((item) => item['status'] == 'Dikeranjang').toList();

    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text("Keranjang kosong", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Abu-abu sangat muda agar card putih pop-out
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: Column(
          children: [
            /// HEADER PILIH SEMUA
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
                          selectedIds = cartItems.map<int>((item) => item['id']).toSet();
                        } else {
                          selectedIds.clear();
                        }
                      });
                    },
                  ),
                  const Text("Pilih Semua", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (selectedIds.isNotEmpty)
                    Text("${selectedIds.length} Item terpilih", style: TextStyle(color: AppColors.primary600, fontSize: 12)),
                ],
              ),
            ),

            /// LIST ITEM
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 10), // Padding bawah agar tidak tertutup bar checkout
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item['product'];

                  return Dismissible(
                    key: ValueKey(item['id']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 25),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                    ),
                    onDismissed: (_) async {
                      await deleteCartItem(item['id']);
                      setState(() {
                        items!.removeWhere((e) => e['id'] == item['id']);
                        selectedIds.remove(item['id']);
                      });
                      TopNotif.success(context, "Item dihapus");
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedIds.contains(item['id']),
                            activeColor: AppColors.primary600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) selectedIds.add(item['id']);
                                else selectedIds.remove(item['id']);
                              });
                            },
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product['image_path'],
                              width: 70, height: 70, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text("Size: ${product['ukuran'] ?? "-"}", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                const SizedBox(height: 6),
                                Text(formatCurrency(product['price']), style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary600, fontSize: 15)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM CHECKOUT BAR
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Harga", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(formatCurrency(getTotal()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary600)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: selectedIds.isEmpty ? null : () => _showDialog(context, getTotal()),
                    child: const Text("Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Fungsi Dialog Pembayaran (QRIS) tetap sama, hanya perapihan styling ---
  void _showDialog(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Text("Pembayaran QRIS", style: TextStyle(fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Pembayaran:", style: TextStyle(color: Colors.grey[600])),
            Text(formatCurrency(total), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary600)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
              child: Image.asset('assets/qris_test.jpg', height: 200),
            ),
            const SizedBox(height: 10),
            const Text("Scan QRIS di atas untuk membayar", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary600, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              _processCheckout();
            },
            child: const Text("Konfirmasi"),
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout() async {
    final token = await UserToken().getToken();
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/proses");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode({"id": selectedIds.toList()}),
    );
    if (response.statusCode == 200) {
      TopNotif.success(context, "Checkout berhasil!");
      fetchItems();
    }
  }
}