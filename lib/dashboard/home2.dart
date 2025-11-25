import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/user-data.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/beranda.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Map<String, dynamic>? userData;
  Future<void> userdata() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await ApiServiceLogin.loginWithUid(uid: user.uid);
      setState(() {
        userData = data;
        print(data);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    userdata();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 393,
              height: 120,
              color: AppColors.primary500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset('assets/logo_home.png',width: 127,height: 30,),

                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    width: 197,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        SizedBox(
                          width:125,
                          height: 30,
                          child: ElevatedButton(onPressed: (){}, child:
                          Text(userData?["location"] ?? "Loading...",style: TextStyle(color: AppColors.grayscale700),)),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child:  Icon(Icons.notifications,color: Colors.white,),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.favorite_border,color: Colors.white,),
                        ),
                      ],
                    ),
                  )
                ],
              ),

            ),

            SizedBox(
              height: 32,
            ),
           Container(width: 361,
             height: 570,
             child:  ListView(
               scrollDirection: Axis.vertical,
               children: [
                 Container(
                   width: 361,
                   height: 122,
                   child: Image.asset('assets/beranda_banner.png'),
                 ),
                 SizedBox(
                   width: 24,
                 ),
                 Container(
                   width: 361,
                   child: Column(
                     spacing: 12,
                     children: [

                       SizedBox(
                         height: 24,
                       ),

                       Container(
                           width: 361,
                           height: 20,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               SizedBox(
                                 width: 24,
                               ),
                               Text("Rekomendasi Produk",style: TextStyle(color: AppColors.primary800,fontWeight: FontWeight.bold
                                   ,fontSize: 14),),

                               SizedBox(
                                 width: 160,
                               ),

                               Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                             ],
                           )
                       ),

                       // dynamic barang
                       Container(
                         width: 361,
                         height: 238,
                         child: ItemBeranda(),
                       ),

                       Container(
                           width: 361,
                           height: 20,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               SizedBox(
                                 width: 24,
                               ),
                               Text("Produk Terbaru",style: TextStyle(color: AppColors.primary800,fontWeight: FontWeight.bold
                                   ,fontSize: 14),),

                               SizedBox(
                                 width: 200,
                               ),

                               Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                             ],
                           )
                       ),

                       Container(
                         width: 361,
                         height: 238,
                         child: ItemBeranda(),
                       ),

                     ],
                   ),
                 )
               ],
             ),)
          ],
        )
      ),
    );
  }
}
