import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes_pm/api/get-all-items.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/detail/detail.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  List<dynamic>? items;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  String formatCurrency(dynamic number) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.parse(number.toString()));
  }

  Future<void> fetchItems() async {
    final result = await GetAllItems().get();
    if (!mounted) return;

    result.sort((a, b) {
      if (a['status'] == 'Ready' && b['status'] != 'Ready') return -1;
      if (a['status'] != 'Ready' && b['status'] == 'Ready') return 1;
      return 0;
    });
    setState(() {
      items = result;
    });
  }

  bool isSoldOut(dynamic item) {
    return item['status'] == 'Sold Out';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Semua Produk",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0.5,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchItems,
          child: items == null
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
            // Padding Grid diperbaiki agar konsisten 16px di semua sisi
            padding: const EdgeInsets.all(16),
            itemCount: items!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.63, // Rasio sedikit ditambah untuk ruang teks bawah
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = items![index];
              final soldOut = isSoldOut(item);

              return GestureDetector(
                onTap: soldOut
                    ? null
                    : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(product_id: item['id'].toString()),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Radius lebih lembut
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ============================
                      /// IMAGE SECTION
                      /// ============================
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              item['image_path'],
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 160,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          if (soldOut)
                            Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "SOLD OUT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                        ],
                      ),

                      /// ============================
                      /// INFO SECTION
                      /// ============================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kondisi Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondary400,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['kondisi'].toString().toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Nama Produk
                            Text(
                              item['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grayscale900,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Ukuran
                            Text(
                              "Size: ${item['ukuran']}",
                              style: TextStyle(
                                color: AppColors.grayscale500,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Harga
                            Text(
                              formatCurrency(item['price']),
                              style: TextStyle(
                                color: AppColors.primary500,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
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