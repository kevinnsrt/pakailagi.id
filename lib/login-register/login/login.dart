import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/login-register/login/login-form.dart';
import 'package:tubes_pm/login-register/register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenHeight = 0;

  // List gambar
  final List<String> images = [
    'assets/splash_1.png',
    'assets/splash_2.png',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, startImageSlider);
  }

  void startImageSlider() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: screenHeight * 0.6,
            decoration: BoxDecoration(
              color: AppColors.grayscale300,
            ),
            child: Image.asset(
              images[currentIndex],
              fit: BoxFit.cover,
            ),
          ),

          // Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Container(
                      width: 361,
                      child: const Text(
                        "Bandingkan produk, temukan penjual, lakukan transaksi dengan siapa saja",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grayscale700,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Container(
                      width: 361,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginForm()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?"),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const RegisterPage()));
                          },
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                                color: AppColors.primary700,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
