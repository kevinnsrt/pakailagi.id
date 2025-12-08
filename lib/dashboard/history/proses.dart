import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;

class ProsesCart extends StatefulWidget {
  const ProsesCart({super.key});

  @override
  State<ProsesCart> createState() => _ProsesCartState();
}

class _ProsesCartState extends State<ProsesCart> {
  List<dynamic>? items;
  // Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   fetchItems();
  // }


  Future<void> fetchItems() async {
    var result = await GetUserCart().prosesCart();
    if (!mounted) return;

    setState(() {
      items = result;
      // selectedIds.clear();
    });
  }

  // bool get selectAll => items != null && items!.every((item) => selectedIds.contains(item['id']));

  @override
  Widget build(BuildContext context) {
    // Future.microtask(() {
    //   fetchItems();
    // });
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items!.isEmpty) {
      return const Center(child: Text("Tidak ada pesanan yang diproses"));
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body:
      RefreshIndicator(onRefresh: fetchItems,
        child:items == null
            ? ListView(
          children: const [
            SizedBox(height: 300),
            Center(child: CircularProgressIndicator()),
          ],
        )
            : items!.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 300),
            Center(child: Text("Keranjang kosong")),
          ],
        ):
      Column(
        children: [
          // Checkbox Pilih Semua
          // Row(
          //   children: [
          //     Checkbox(
          //       value: selectAll,
          //       onChanged: (value) {
          //         setState(() {
          //           if (value == true) {
          //             selectedIds = items!.map<int>((item) => item['id']).toSet();
          //           } else {
          //             selectedIds.clear();
          //           }
          //           print("Selected IDs: $selectedIds"); // <-- debug di sini
          //         });
          //       },
          //     ),
          //     const Text("Pilih Semua")
          //   ],
          // ),

          Expanded(
           child: ListView.builder(
             itemCount: items!.length,
             itemBuilder: (context, index) {
               final item = items![index];
               final product = item['product'];

               return Container(
                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 padding: const EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8),
                   color: Colors.white,
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black12,
                       blurRadius: 4,
                       offset: Offset(0, 2),
                     )
                   ],
                 ),
                 child: Column(
                   children: [
                     // Status
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

                     // Item Row
                     Row(
                       children: [
                         // Checkbox Item
                         // Checkbox(
                         //   value: selectedIds.contains(item['id']),
                         //   onChanged: (value) {
                         //     setState(() {
                         //       if (value == true) {
                         //         selectedIds.add(item['id']);
                         //       } else {
                         //         selectedIds.remove(item['id']);
                         //       }
                         //       print("Selected IDs: $selectedIds");
                         //     });
                         //   },
                         // ),

                         // Gambar
                         Image.network(items![index]['product']['image_path'],width: 70,height: 70,),
                         const SizedBox(width: 12),

                         // Text Info (flexible)
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
      // floatingActionButton: FloatingActionButton(onPressed: () async{
      //   List<int> idToPost = selectedIds.toList();
      //   final token = await UserToken().getToken();
      //
      //   final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/proses");
      //
      //   final response = await http.post(url,
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Authorization": "Bearer $token",
      //   },
      //     body: jsonEncode({
      //       "id":idToPost
      //     })
      //   );
      //
      //   if(response.statusCode == 200){
      //     print("Barang berhasil di checkout");
      //     fetchItems();
      //   }
      // },
      //   child: Icon(Icons.shopping_cart_checkout,color: AppColors.primary500,),
      //   backgroundColor: Colors.white,
      // ),
    )
    );
  }
}
