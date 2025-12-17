import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> fetchItems() async {
    final result = await GetUserCart().getusercart();
    if (!mounted) return;

    setState(() {
      items = result;
      selectedIds.clear();
    });
  }

  Future<void> refresh() async {
    await fetchItems();
  }


  void _showDialog(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          // Menggunakan SizedBox untuk membatasi tinggi dialog
          height: 350,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar kolom mengikuti isi
            crossAxisAlignment: CrossAxisAlignment.center, // Perbaikan di sini
            children: [
              Text(
                "Silahkan lakukan pembayaran:\nIDR $total",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/qris_test.jpg',
                      fit: BoxFit.contain, // BoxFit menggunakan contain, bukan CrossAxis
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary600,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // ... logika checkout Anda tetap sama ...
              Navigator.pop(context);
              // Lanjutkan proses API seperti kode sebelumnya
            },
            child: const Text("Konfirmasi Pembayaran"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteCartItem(int id) async {
    final token = await UserToken().getToken();
    if (token == null) return;

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/delete/$id");
    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) throw Exception("Gagal hapus item");
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
    return cartItems.isNotEmpty &&
        cartItems.every((item) => selectedIds.contains(item['id']));
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final cartItems = items!.where((item) => item['status'] == 'Dikeranjang').toList();

    if (cartItems.isEmpty) {
      return const Center(child: Text("Keranjang kosong"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchItems,
        child: Column(
          children: [
            /// HEADER PILIH SEMUA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    activeColor: AppColors.primary600,
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

                  return Dismissible(
                    key: ValueKey(item['id']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (_) async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Hapus item?"),
                          content: const Text("Item akan dihapus dari keranjang"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await deleteCartItem(item['id']);
                          return true;
                        } catch (_) {
                          TopNotif.error(context, "Gagal menghapus item");
                          return false;
                        }
                      }
                      return false;
                    },
                    onDismissed: (_) {
                      setState(() {
                        items!.removeWhere((e) => e['id'] == item['id']);
                        selectedIds.remove(item['id']);
                      });
                      TopNotif.success(context, "Item berhasil dihapus");
                    },
                    child: Container(
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
                          )
                        ],
                      ),
                      child: Row(
                        children: [
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
                          ),

                          /// GAMBAR PRODUK
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              product['image_path'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 80,
                                  height: 80,
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
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// INFO PRODUK
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Size: ${product['ukuran'] ?? "-"}",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "IDR ${product['price']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary600,
                                    ),
                                  ),
                                ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Total: IDR ${getTotal()}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            FloatingActionButton.extended(
              backgroundColor: AppColors.primary600,
              onPressed: selectedIds.isEmpty ? null : () => _showDialog(context, getTotal()),
              label: const Text("Checkout", style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}