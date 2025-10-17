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
          SizedBox(height: 75,),
          Text("Halo Sobat !",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
          SizedBox(height: 30,),
          Text("Selamat datang kembali, kami merindukanmu",
          textAlign: TextAlign.center,
          maxLines: 2,style: TextStyle(fontSize: 20),),

          SizedBox(height: 80,),
          SizedBox(width: 320,
          height: 60,
          child:TextField(decoration: InputDecoration(labelText: "Masukkan Username",border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),)
          ,),

          SizedBox(height: 30,),

           SizedBox(width: 320,
          height: 60,
          child:TextField(decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),)
          ,),

          SizedBox(height: 15,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 127,
              child: Text("Lupa Password ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),),
              SizedBox(width: 36,),
            ],
          ),

          SizedBox(height: 56,),

          SizedBox(
            width: 320,
            height: 65,
            child:  ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                backgroundColor: Color.fromRGBO(55, 152, 90, 1),
                foregroundColor: Colors.white
              ),
              onPressed: (){

          }, child: Text("Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),)),
          ),

          SizedBox(height: 48,),

          Text("atau lanjutkan dengan"),

          SizedBox(height: 19,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SizedBox(
            width: 60,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero, // supaya gambar benar-benar pas
              ),
              onPressed: () {},
              child: Image.asset(
                "assets/logo_google.png",
                fit: BoxFit.cover, // biar gambar memenuhi tombol
              ),
            ),
          ),

              SizedBox(width: 60,),
 
              SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero, // supaya gambar benar-benar pas
                ),
                onPressed: () {},
                child: Image.asset(
                  "assets/logo_apple.png",
                  fit: BoxFit.cover, // biar gambar memenuhi tombol
                ),
              ),
            )
 
             
            ],
          )
          ],
      ),
    );
  }
}