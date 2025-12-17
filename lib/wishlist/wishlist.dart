import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/detail/detail.dart';
import 'package:tubes_pm/widget/top_notif.dart';

class WishlistPage extends StatefulWidget {

  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<dynamic>? items;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final token = await UserToken().getToken();
    if (token == null) return;

    final url = Uri.parse(
        "https://pakailagi.user.cloudjkt02.com/api/wishlist/user");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) return;

    final result = json.decode(response.body);
    print(result);
    if (!mounted) return;

    // sorting
    // result.sort((a, b) {
    //   if (a['status'] == 'Ready' && b['status'] != 'Ready') {
    //     return -1;
    //   }
    //   if (a['status'] != 'Ready' && b['status'] == 'Ready') {
    //     return 1;
    //   }
    //   return 0;
    // });
    setState(() {
      items = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchItems,
          child: items == null
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items!.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final item = items![index];
              final product = item['product'];
              return GestureDetector(
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        product_id: item['id'].toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE + SOLD OUT OVERLAY
                      Stack(
                        children: [
                          Image.network(
                            product['image_path'],
                            width: double.infinity,
                            height: 169,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 50,
                              );
                            },
                          ),

                        ],
                      ),

                      const SizedBox(height: 6),

                      /// KONDISI
                      Container(
                        width: 109,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.secondary400,
                          borderRadius:
                          BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          product['kondisi'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// NAMA
                      Text(
                        product['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.grayscale900,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// UKURAN
                      Text(
                        product['ukuran'].toString(),
                        style: TextStyle(
                          color: AppColors.grayscale500,
                          fontSize: 10,
                        ),
                      ),

                      /// PRICE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "RP ${product['price']}",
                            style: TextStyle(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final token = await UserToken().getToken();
                              if (token == null) return;

                              final url = Uri.parse(
                                "https://pakailagi.user.cloudjkt02.com/api/delete/${item['id']}",
                              );

                              final response = await http.delete(
                                url,
                                headers: {
                                  "Authorization": "Bearer $token",
                                },
                              );

                              if (response.statusCode == 200) {
                                await fetchItems();
                                TopNotif.success(context, "Wishlist dihapus");
                              } else {
                                TopNotif.error(context, "Wishlist gagal dihapus");
                              }
                            },

                            child: Icon(Icons.delete,color: Colors.red,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
