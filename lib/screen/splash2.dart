import 'package:flutter/material.dart';
import 'package:tubes_pm/screen/login.dart';

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

          SizedBox(height: 35),
          SizedBox(
            width: 300,
            child: Text(
              "Pakai Lagi, Selamatkan Bumi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 35),
          SizedBox(
            width: 300,
            child: Text(
              "Setiap pakaian yang kamu pakai ulang berarti satu langkah lebih hijau bagi lingkungan.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 80),

          SizedBox(
            width: 284,
            height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(55, 152, 90, 1),
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
                "Get Started",
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
