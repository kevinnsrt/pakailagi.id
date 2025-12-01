import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get-all-items.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/detail/detail.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  var items;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    var result = await GetAllItems().get();
    if (!mounted) return;
    setState(() {
      items = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: fetchItems,
        child:
        items ==null ? Center(child: CircularProgressIndicator(),):
        GridView.builder(
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(product_id: item['id'].toString())));
              },
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
        ), ),),
    );
  }
}
