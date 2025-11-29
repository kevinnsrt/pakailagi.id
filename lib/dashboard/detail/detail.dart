import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(child: Expanded(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            // container image
            Container(
              width: 393,
              height: 393,
              color: Colors.green,
            ),

            // container kategori
            Container(
              width: 324,
              height: 30,
              color: Colors.yellow,
            ),

          //   container detail
            Container(
              width: 324,
              height: 94,
              color: Colors.blue,
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            SizedBox(
              width: 171,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: AppColors.secondary500
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  onPressed: (){}, child: Text("Keranjang",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary500
              ),)),
            ),

            SizedBox(
              width: 173,
              height: 48,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      )
                  ),
                  onPressed: (){}, child: Text("Beli",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),)),
            ),
          ],
        ),
      ),
    );
  }
}
