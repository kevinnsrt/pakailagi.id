import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(55, 192, 90, 1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            SizedBox(height: 37,),
            Image.asset("assets/pakailagi.id.png"),
          ],
        )
      ),
    );
  }
}