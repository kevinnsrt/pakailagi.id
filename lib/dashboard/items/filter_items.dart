import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/dashboard/detail/detail.dart';

class FilterPage extends StatefulWidget {
  final String value; // kategori

  const FilterPage({super.key, required this.value});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
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
        "https://pakailagi.user.cloudjkt02.com/api/products/kategori");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "kategori": widget.value,
      }),
    );

    if (response.statusCode != 200) return;

    final result = json.decode(response.body);
    if (!mounted) return;

    setState(() {
      items = result;
    });
  }

  bool isSoldOut(dynamic item) {
    return item['status'] == 'Sold Out';
    // alternatif:
    // return item['stok'] == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              final soldOut = isSoldOut(item);

              return GestureDetector(
                onTap: soldOut
                    ? null
                    : () {
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
                            item['image_path'],
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
                          if (soldOut)
                            Container(
                              width: double.infinity,
                              height: 169,
                              color:
                              Colors.black.withOpacity(0.5),
                              alignment: Alignment.center,
                              child: const Text(
                                "SOLD OUT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
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
                          item['kondisi'],
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
                        item['name'],
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
                        item['ukuran'].toString(),
                        style: TextStyle(
                          color: AppColors.grayscale500,
                          fontSize: 10,
                        ),
                      ),

                      /// PRICE
                      Text(
                        "RP ${item['price']}",
                        style: TextStyle(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
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
