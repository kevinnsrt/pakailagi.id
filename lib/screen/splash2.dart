import 'package:flutter/material.dart';
import 'package:smooth_transition/smooth_transition.dart';
import 'package:tubes_pm/login-register/login/login.dart';
import 'package:tubes_pm/screen/splash3.dart';

class SplashPage2 extends StatefulWidget {
  const SplashPage2({super.key});

  @override
  State<SplashPage2> createState() => _SplashPage2State();
}

class _SplashPage2State extends State<SplashPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
        children: [
          SizedBox(height: 24),
          Image.asset("assets/login_logo.png", width: 366, height: 366),

          SizedBox(height: 30),
          SizedBox(
            width: 300,
            child: Text(
              "Ekspresikan Gaya Hijau",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 30),
          SizedBox(
            width: 300,
            child: Text(
              "Bandingakan Produk, temukan penjual terpercaya, nikmati proses jual beli yang aman.",
              style: TextStyle(fontSize: 16,color: Color.fromRGBO(55, 65, 81, 1)),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 38),

          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Container(
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color:Color.fromRGBO(64, 138, 142, 1), ),
                 width: 48,
                 height: 8,
               ),
                SizedBox(width: 8,),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color:Color.fromRGBO(156, 163, 175, 1), ),
                  width: 48,
                  height: 8,
                ),
              ],
            ),
          ),

          SizedBox(
            height: 38,
          ),

          SizedBox(
            width: 362,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(64, 138, 142, 1),
              ),
              onPressed: () {
                Navigator.push(context, PageTransition(
                    child: const SplashPage3(),
                    type: PageTransitionType.slideLeftFade,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                ));
              },
              child: Text(
                "Selanjutnya",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
