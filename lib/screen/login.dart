import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height:24,),
          Image.asset("assets/login_logo.png",
          width: 366,
          height: 366,),

          SizedBox(height: 35,),
          SizedBox(width: 300,
          child: Text("Pakai Lagi, Selamatkan Bumi",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),) ,),

          SizedBox(height: 35,),
          SizedBox(width: 300,
          child: Text("Setiap pakaian yang kamu pakai ulang berarti satu langkah lebih hijau bagi lingkungan.",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,maxLines: 3,),),
          SizedBox(height: 80,),

          SizedBox(
            width: 284,
            height: 65,
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
              foregroundColor: Colors.white,backgroundColor: Color.fromRGBO(55, 152, 90, 1)),
            onPressed: (){}, child: Text("Get Started")),
          ),
          
        ],
      ),
    );
  }
}