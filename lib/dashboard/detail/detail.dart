import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_details_product.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/bottom-navbar.dart';
import 'package:tubes_pm/dashboard/history/history.dart';

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
    final data = await GetDetailsProduct.getDetailsProduct(id: widget.product_id);
    setState(() {
      detailProducts = data;
    });
  }
  
  Future<void> sendToCart() async{
    final cred = await FirebaseAuth.instance.currentUser;
    final uid = cred!.uid.toString();
    final token = UserToken().getToken().toString();
    
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts");

    final response = await http.post(url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
      body: jsonEncode({
        "uid": uid,
        "product_id": widget.product_id
      })
    );

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print("PRODUCT ID: ${widget.product_id}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: detailProducts == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Image.network(
                detailProducts!['image_path'],
                width: 393,
                height: 393,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 12),

              // Kategori
            Container(
              width: 324,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  // Kondisi
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Kategori
                  Expanded(
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,   // INI YANG BIKIN TEXT DI TENGAH
                      child: Text(
                        detailProducts!['kategori'],
                        style: TextStyle(
                          color: AppColors.grayscale500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

              // Detail
              Container(
                width: 324,
                height: 94,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(detailProducts!['name'],style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),

                  //   lokasi
                    Text(detailProducts!['deskripsi'],style: TextStyle(
                      fontSize: 16
                    ),),

                  //   price
                    Text("IDR ${detailProducts!['price'].toString()}",style: TextStyle(
                      color: AppColors.primary500,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),)

                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // tombol keranjang
            SizedBox(
              width: 171,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.secondary500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Keranjang",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary500,
                  ),
                ),
              ),
            ),

            SizedBox(width: 8),

            // tombol beli
            SizedBox(
              width: 173,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async{
                  await sendToCart();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(selectedIndex: 3,)));
                },
                child: Text(
                  "Beli",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
