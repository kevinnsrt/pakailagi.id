import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_details_product.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/bottom-navbar.dart';

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

  @override
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product_id != widget.product_id) {
      detailProducts = null;
      detailsProduct();
    }
  }

  Future<void> detailsProduct() async {
    final data = await GetDetailsProduct.getDetailsProduct(
        id: widget.product_id);
    setState(() {
      detailProducts = data;
    });
  }

  bool get isSoldOut {
    if (detailProducts == null) return false;
    return detailProducts!['status'] == 'Sold Out';
  }

  Future<void> sendToCart() async {
    if (isSoldOut) return;

    final cred = FirebaseAuth.instance.currentUser;
    final uid = cred!.uid;
    final token = await UserToken().getToken();

    final url =
    Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "uid": uid,
        "product_id": widget.product_id,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.statusCode == 200 ||
            response.statusCode == 201
            ? "Berhasil ditambahkan ke keranjang"
            : "Gagal menambahkan ke keranjang"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: detailProducts == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              /// ============================
              /// IMAGE + SOLD OUT OVERLAY
              /// ============================
              Stack(
                children: [
                  Image.network(
                    detailProducts!['image_path'],
                    width: double.infinity,
                    height: 393,
                    fit: BoxFit.cover,
                  ),

                  if (isSoldOut)
                    Container(
                      width: double.infinity,
                      height: 393,
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: const Text(
                        "SOLD OUT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              /// ============================
              /// KATEGORI & KONDISI
              /// ============================
              Container(
                width: 324,
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.secondary400,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Kondisi: ${detailProducts!['kondisi']}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        detailProducts!['kategori'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.grayscale500),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Barang menjadi idamanmu")),
                          );
                        } else {
                          print(response.statusCode);
                          print(response.body);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Barang sudah ada di wishlist")));
                        }
                      },
                      child: const Icon(Icons.favorite_border),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ============================
              /// DETAIL
              /// ============================
              Container(
                width: 324,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detailProducts!['name'],
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(detailProducts!['deskripsi']),
                    const SizedBox(height: 6),
                    Text(
                      "IDR ${detailProducts!['price']}",
                      style: TextStyle(
                        color: AppColors.primary500,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// ============================
      /// BOTTOM BUTTON (HILANG JIKA SOLD OUT)
      /// ============================
      bottomNavigationBar: isSoldOut
          ? null
          : BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 171,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: AppColors.secondary500),
                ),
                onPressed: sendToCart,
                child: Text(
                  "Keranjang",
                  style: TextStyle(
                    color: AppColors.secondary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 173,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.secondary500,
                ),
                onPressed: () async {
                  await sendToCart();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HomePage(selectedIndex: 3),
                    ),
                  );
                },
                child: const Text(
                  "Beli",
                  style: TextStyle(
                    color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
