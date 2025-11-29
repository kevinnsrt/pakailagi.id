import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_transition/smooth_transition.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/history/history.dart';
import 'package:tubes_pm/dashboard/home2.dart';
import 'package:tubes_pm/dashboard/profile.dart';
import 'package:tubes_pm/dashboard/shop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  final List<Widget> _screen = [
    HomePage2(),
    ProfilePage(),
    ShopPage(),
    HistoryPage(),
  ];

  void _onTapped (int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            GestureDetector(
                onTap: (){
                  _onTapped(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.home_filled,color: AppColors.grayscale500,),
                    Text("Home",style: TextStyle(color: AppColors.grayscale500,fontWeight: FontWeight.bold),),
                  ],
                )
            ),

            GestureDetector(
              onTap: () async{
                await UserToken().getToken();
                _onTapped(2);
              },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_rounded,color: AppColors.grayscale500,),
                    Text("Shop",style: TextStyle(color: AppColors.grayscale500,fontWeight: FontWeight.bold),),
                  ],
                )
            ),

            GestureDetector(
              onTap: (){
               _onTapped(3);
              },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.list,color: AppColors.grayscale500,),
                    Text("History",style: TextStyle(color: AppColors.grayscale500,fontWeight: FontWeight.bold),),
                  ],
                )
            ),

            GestureDetector(
              onTap: (){
                _onTapped(1);
              },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person,color: AppColors.grayscale500,),
                    Text("Profile",style: TextStyle(color: AppColors.grayscale500,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screen,
      ),
    );

  }
}
