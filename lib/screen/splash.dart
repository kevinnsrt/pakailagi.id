import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_transition/smooth_transition.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/screen/splash2.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void _navigateToNextScreen(){
    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade,
        curve: Curves.easeIn,
        child: SplashPage2(),duration: Duration(milliseconds: 300,) ));
  }
  @override
  void initState(){
    super.initState();
    Timer(
      Duration(milliseconds: 2500),
      _navigateToNextScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayscale50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",width: 197,height: 174,),
          ],
        ),
      ),
    );
  }
}
