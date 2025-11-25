import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get-all-items.dart';
import 'package:tubes_pm/colors/colors.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  var items;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    var result = await GetAllItems().get();
    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(      
        onRefresh: fetchItems,     
        child: SafeArea(
          child: items == null      
              ? Center(child: CircularProgressIndicator())
              : Center(
            child: Column(
              children: [
                SizedBox(height: 12),

                // ===== TOP BAR =====
                Container(
                  width: 361,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 120,
                    children: [
                      Text(
                        "Belanja",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grayscale900,
                        ),
                      ),
                      Container(
                        width: 155,
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              color: AppColors.primary700,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

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

                // ===== CATEGORY LIST =====
                Container(
                  width: 361,
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(2),
                    children: [
                      _categoryButton("Tops"),
                      _categoryButton("Bottoms"),
                      _categoryButton("Outerwears"),
                      _categoryButton("Bags"),
                      _categoryButton("Accessories"),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // ===== PRODUCT GRID =====
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(4, 4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                item['image_path'],
                                width: 169,
                                height: 169,
                                errorBuilder: (context, error, stackTrace) {
                                  print("IMAGE LOAD ERROR: $error");
                                  return Icon(Icons.broken_image, size: 50);
                                },
                              ),
                              SizedBox(height: 6),

                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(163, 203, 56, 1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                width: 109,
                                height: 18,
                                child: Center(
                                  child: Text(
                                    item['kondisi'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: AppColors.grayscale900,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                item['ukuran'].toString(),
                                style: TextStyle(
                                  color: AppColors.grayscale500,
                                  fontSize: 10,
                                ),
                              ),

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

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _categoryButton(String label) {
    return SizedBox(
      width: 100,
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
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
