import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // top
            Container(
              width: 361,
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 120,
                children: [
                  Text("Belanja",style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayscale900
                  ),),

                  Container(
                    width: 155,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border_outlined,color: AppColors.primary700,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          //   end container top

          //   gap
            SizedBox(
              height: 12,
            ),
          //   end gap

          //   container search bar
            Container(
              width: 361,
              height: 46,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.search,color: AppColors.grayscale500,),
                      Text("Search for item ...",style: TextStyle(color: AppColors.grayscale500),)
                    ],
                  )
                ),
              ),
            ),
          //   end container search bar
          // gap
            SizedBox(
              height: 16,
            ),
          //   start container category
            Container(
            width: 361,
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsGeometry.all(2),
                children: [
                  SizedBox(
                    width: 76,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                      ),
                      onPressed: (){}, child: Text("Tops",style: TextStyle(color: AppColors.grayscale900,fontSize: 12),),)
                  ),

                  SizedBox(
                      width: 96,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                            ),
                        ),
                        onPressed: (){}, child: Text("Bottoms",style: TextStyle(color: AppColors.grayscale900,fontSize: 12),),)
                  ),

                  SizedBox(
                      width: 116,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                            ),
                        ),
                        onPressed: (){}, child: Text("Outerwears",style: TextStyle(color: AppColors.grayscale900,fontSize: 12),),)
                  ),

                  SizedBox(
                      width: 76,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                            ),
                        ),
                        onPressed: (){}, child: Text("Bags",style: TextStyle(color: AppColors.grayscale900,fontSize: 12),),)
                  ),

                  SizedBox(
                      width: 116,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                            ),
                        ),
                        onPressed: (){}, child: Text("Accessories",style: TextStyle(color: AppColors.grayscale900,fontSize: 12),),)
                  ),
                ],
              ),
            ),
          //   end container category

          //   gap
            SizedBox(
              height: 12,
            ),
          //   start container card
            Container(
              width: 361,
              height: 508,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    width: 169,
                    height: 254,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('asstes/test.jpg'),
                        Text("Kondisi: Like New"),
                        Text("Zara Longsleeve"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on),
                            Text("Medan")
                          ],
                        ),
                        Text("RP 200.000"),
                      ],
                    )
                  ),
                ),


              ],),
            ),

          //   end container card
          ],
        ),
      )),
    );
  }
}
