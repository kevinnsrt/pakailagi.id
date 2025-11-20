import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Container(
                    width: 150,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(62, 138, 142, 1),
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),

                  Container(
                    width: 150,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(156, 163, 172, 1),
                        borderRadius: BorderRadius.circular(12)
                    ),
                  ),

                ],
              ),
            ),
          ],
      )),
    ),
    );
  }
}
