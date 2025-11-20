import 'package:flutter/material.dart';
import 'package:tubes_pm/login-register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 118,
                    child: Image.asset('assets/logo2.png'),
                  ),

                  SizedBox(
                    height: 12,
                  ),
                  Text("Pakai Lagi, Selamatkan Bumi",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Text("Setiap pakaian yang kamu pakai ulang berarti satu langkah lebih hijau bagi lingkungan.",textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),),

                ],
              ),
            ),

            SizedBox(
              height: 111,
            ),

            Container(
              width: 362,
              height: 108,
              child: Column(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 362,
                    height: 48,
                    child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromRGBO(62, 138, 142, 1),
                      foregroundColor: Colors.white
                    ),onPressed: (){

                    }, child: Text("Masuk",style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),

                  SizedBox(
                    width: 362,
                    height: 48,
                    child:  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(243, 244, 246, 1),
                        foregroundColor: Color.fromRGBO(37, 70, 74, 1),
                          elevation: 5,
                    ),onPressed: (){
                      Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>const RegisterPage()));
                    },
                     child: Text("Daftar",style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
