import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl
import 'package:tubes_pm/api/get_details_product.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/bottom-navbar.dart';
import 'package:tubes_pm/widget/top_notif.dart';

class DetailPage extends StatefulWidget {
  final String product_id;
  const DetailPage({super.key, required this.product_id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detailProducts;

  @override
  void initState() {
    super.initState();
    detailsProduct();
  }

  // Fungsi format rupiah
  String formatCurrency(dynamic number) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.parse(number.toString()));
  }

  Future<void> detailsProduct() async {
    final data = await GetDetailsProduct.getDetailsProduct(id: widget.product_id);
    setState(() {
      detailProducts = data;
    });
  }

  bool get isSoldOut => detailProducts?['status'] == 'Sold Out';

  Future<void> sendToCart() async {
    if (isSoldOut) return;
    final cred = FirebaseAuth.instance.currentUser;
    final uid = cred!.uid;
    final token = await UserToken().getToken();

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"uid": uid, "product_id": widget.product_id}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      TopNotif.success(context, "Berhasil ditambahkan ke keranjang");
    } else {
      TopNotif.error(context, "Barang sudah ada di keranjang");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white, // Agar tetap putih saat scroll
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: detailProducts == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SECTION
            Stack(
              children: [
                Image.network(
                  detailProducts!['image_path'],
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                if (isSoldOut)
                  Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: const Text(
                      "SOLD OUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BADGES & WISHLIST
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary400,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Kondisi: ${detailProducts!['kondisi']}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        detailProducts!['kategori'],
                        style: TextStyle(color: AppColors.grayscale500, fontSize: 12),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async{
                          final token = await FirebaseAuth.instance.currentUser!.getIdToken();

                          final url = Uri.parse(
                            "https://pakailagi.user.cloudjkt02.com/api/wishlist",
                          );

                          final response = await http.post(
                            url,
                            headers: {
                              "Content-Type": "application/json",
                              "Accept": "application/json",
                              "Authorization": "Bearer $token",
                            },
                            body: jsonEncode({
                              "product_id": detailProducts!['id'].toString(),
                            }),
                          );

                          if (response.statusCode == 200 || response.statusCode == 201) {
                            TopNotif.success(context, "Barang berhasil ditambahkan ke wishlist");
                          } else {
                            print(response.statusCode);
                            print(response.body);
                            TopNotif.error(context, "Barang sudah ada di wishlist");
                          }                        },
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// NAME & PRICE
                  Text(
                    detailProducts!['name'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(detailProducts!['price']),
                    style: TextStyle(
                      color: AppColors.primary500,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
                    "Deskripsi Produk",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detailProducts!['deskripsi'] ?? "Tidak ada deskripsi",
                    style: TextStyle(
                      color: AppColors.grayscale600,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 100), // Space extra untuk scroll
                ],
              ),
            ),
          ],
        ),
      ),

      /// ACTION BUTTONS
      bottomNavigationBar: isSoldOut
          ? null
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.secondary500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: sendToCart,
                  child: Text(
                    "Keranjang",
                    style: TextStyle(color: AppColors.secondary500, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary500,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await sendToCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage(selectedIndex: 3)),
                    );
                  },
                  child: const Text(
                    "Beli Sekarang",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}