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
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayscale50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, PageTransition(
                  child: const SplashPage2(),
                  type: PageTransitionType.scaleFade,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ));
              },
              child: Image.asset("assets/logo.png",width: 197,height: 174,),
            ),
          ],
        ),
      ),
    );
  }
}
