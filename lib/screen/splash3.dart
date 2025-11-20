import 'package:flutter/material.dart';
import 'package:tubes_pm/screen/login.dart';

class SplashPage3 extends StatefulWidget {
  const SplashPage3({super.key});

  @override
  State<SplashPage3> createState() => _SplashPage3State();
}

class _SplashPage3State extends State<SplashPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
        children: [
          SizedBox(height: 24),
          Image.asset("assets/login_logo.png", width: 366, height: 366),

          SizedBox(height: 35),
          SizedBox(
            width: 300,
            child: Text(
              "Jual Cepat & Aman",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 35),
          SizedBox(
            width: 300,
            child: Text(
              "Unggah barang dengan mudah, atur pesanan, dan temukan pembeli yang tepat untuk preloved-mu",
              style: TextStyle(fontSize: 16,color: Color.fromRGBO(55, 65, 81, 1)),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 52),

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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color:Color.fromRGBO(64, 138, 142, 1), ),
                  width: 48,
                  height: 8,
                ),
              ],
            ),
          ),

          SizedBox(
            height: 60,
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
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const LoginPage(),
                  ),
                );
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
