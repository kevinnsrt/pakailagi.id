import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12,),
          Image.asset("assets/login_logo.png",
          width: 366,
          height: 366,),

         Row( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pakai Lagi, Selamatkan Bumi",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),) ,
          ],
         ),
          

          Text("Setiap pakaian yang kamu pakai ulang berarti satu langkah lebih hijau bagi lingkungan."),
          SizedBox(height: 129,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Color.fromRGBO(55, 152, 90, 1)),
            onPressed: (){}, child: Text("Get Started"))
          
        ],
      ),
    );
  }
}