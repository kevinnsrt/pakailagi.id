import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/colors/colors.dart';

class CartAll extends StatefulWidget {
  const CartAll({super.key});

  @override
  State<CartAll> createState() => _CartAllState();
}

class _CartAllState extends State<CartAll> {
  List<dynamic>? items;
  bool selectAll = false;
  List<bool> selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    var result = await GetUserCart().getusercart();
    if (!mounted) return;

    setState(() {
      items = result;
      selectedItems = List<bool>.filled(items!.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items!.isEmpty) {
      return const Center(child: Text("Keranjang kosong"));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Checkbox Pilih Semua
          Row(
            children: [
              Checkbox(
                value: selectAll,
                onChanged: (value) {
                  setState(() {
                    selectAll = value!;
                    selectedItems = List<bool>.filled(items!.length, selectAll);
                  });
                },
              ),
              const Text("Pilih Semua")
            ],
          ),

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
                          Checkbox(
                            value: selectedItems[index],
                            onChanged: (value) {
                              setState(() {
                                selectedItems[index] = value!;
                                selectAll =
                                    selectedItems.every((element) => element);
                              });
                            },
                          ),

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
    );
  }
}
