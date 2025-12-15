
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/get_user_cart.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/history/all.dart';
import 'package:tubes_pm/dashboard/history/proses.dart';
import 'package:tubes_pm/dashboard/history/selesai.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Future<void> allusercart() async{
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   if(user != null){
  //     final data = await GetUserCart.getusercart(uid: user.uid);
  //   }
  //
  // }
  @override

  int _selectedIndex = 0;

  final List<Widget> _screen = [
    CartAll(),
    ProsesCart(),
    SelesaiPage(),
  ];

  void _onTapped (int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Histori",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 347,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 InkWell(
                   onTap: (){
                     _onTapped(0);
                   },
                   child:  Text("Dikeranjang",style: TextStyle(color: AppColors.grayscale950,fontWeight: FontWeight.bold,fontSize: 16),),
                 ),
                  InkWell(
                    onTap: (){
                      _onTapped(1);
                    },
                    child: Text("Diproses",style: TextStyle(color: AppColors.grayscale950,fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                 InkWell(
                   onTap: (){
                     _onTapped(2);
                   },
                   child:  Text("Selesai",style: TextStyle(color: AppColors.grayscale950,fontWeight: FontWeight.bold,fontSize: 16),),
                 ),
                  Text("Dibatalkan",style: TextStyle(color: AppColors.grayscale950,fontWeight: FontWeight.bold,fontSize: 16),),
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),

            Expanded(child: IndexedStack(
              index: _selectedIndex,
              children: _screen,
            ),)
          ],
        ),
      )),
    );
  }
}
