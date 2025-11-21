import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Center(
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 358,
                  height: 8,
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 175,
                        height: 8,
                        decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),

                      Container(
                        width: 175,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(156, 163, 172, 1),
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                Container(
                  width: 358,
                  height: 104,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Image.asset('assets/register_logo.png'),
                      Text("Bergabunglah dengan Pakailagi.id untuk gaya yang lebih jauh!",textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 32,
                ),

                Container(
                  width: 365,
                  height: 344,
                  child: Column(
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          SizedBox(
                          width:355,
                            height: 20,
                            child: Text("Nama Lengkap",style: TextStyle(color: AppColors.primary500),),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Nama Lengkap Kamu",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          SizedBox(
                            width:355,
                            height: 20,
                            child: Text("Email",style: TextStyle(color: AppColors.primary500,)),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Alamat Email Kamu",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        spacing: 8,
                        children: [
                          SizedBox(
                            width:355,
                            height: 20,
                            child: Text("Kata Sandi",style: TextStyle(color: AppColors.primary500,)),
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Masukkan kata sandi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        spacing: 8,
                        children: [
                          SizedBox(
                            width:355,
                            height: 20,
                            child: Text("Konfirmasi Kata Sandi",style: TextStyle(color: AppColors.primary500,)),
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Konfirmasi Kata Sandi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32,),
                Container(
                  width: 362,
                  height: 108,
                  child: Column(
                    spacing: 12,
                    children: [
                      SizedBox(
                        width: 362,
                        height: 48,
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(62, 138, 142, 1),
                                foregroundColor: Colors.white
                            ),onPressed: (){

                        }, child: Text("Selanjutnya",style: TextStyle(fontWeight: FontWeight.bold),)),
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
                          Navigator.pop(context);
                        },
                            child: Text("Batal",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 28,),

                Container(
                  width: 168,
                  height: 93,
                  child: Column(
                    spacing: 10,
                    children: [
                      Text("atau lanjutkan dengan"),
                      Container(
                        width: 168,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 48,
                          children: [
                            GestureDetector(onTap: (){
                              
                            },
                            child: Image.asset('assets/logo_google.png',width: 40,height: 40,),
                            ),
                            GestureDetector(onTap: (){

                            },
                              child: Image.asset('assets/logo_apple.png',width: 40,height: 40,),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    )
    );
  }
}
