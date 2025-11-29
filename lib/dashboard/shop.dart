import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get-all-items.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/all_items.dart';
import 'package:tubes_pm/dashboard/items/filter_items.dart';



class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  var items;
  String selectedCategory = "";
  int _selectedIndex = 0;

  void _onTapped(int index, [String? category]) {
    setState(() {
      _selectedIndex = index;
      if (category != null) selectedCategory = category;
    });
  }

  final List<Widget> _screen = [];

  @override
  Widget build(BuildContext context) {
    final screens = [
      AllItemsPage(),
      FilterPage(
          key: ValueKey(selectedCategory)
      ,value: selectedCategory),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Belanja",style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          Icon(Icons.favorite_border_outlined),
          SizedBox(width: 12,)
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // top bar
            SizedBox(height: 12),
            // ===== SEARCH BAR =====
            Container(
              width: 361,
              height: 46,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Row(
                    children: [
                      Icon(Icons.search,
                          color: AppColors.grayscale500),
                      Text(
                        "Search for item ...",
                        style:
                        TextStyle(color: AppColors.grayscale500),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Container(
              width: 361,
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(2),
                children: [
                  _categoryButton("Tops", "Atasan"),
                  _categoryButton("Bottoms", "Bawahan"),
                  _categoryButton("Outerwears", "Outer"),
                  _categoryButton("Bags", "Tas"),
                  _categoryButton("Shoes", "Sepatu"),
                  _categoryButton("Accessories", "Accessories"),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: screens,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(String label, String value) {
    return SizedBox(
      width: 116,
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          _onTapped(1, value); // 1 = FilterPage, kirim kategori
        },
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.grayscale900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}