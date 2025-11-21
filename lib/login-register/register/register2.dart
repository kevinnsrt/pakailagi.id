import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/register_auth.dart';
import 'package:tubes_pm/colors/colors.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _number = TextEditingController();
  final TextEditingController _location = TextEditingController();


  // late String _username ;
  // late String _mail;
  // late String _password;
  // late String _confirmPassword;

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
                            color: AppColors.primary500,
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
                            child: Text("Nomor Telepon",style: TextStyle(color: AppColors.primary500),),
                          ),
                          TextField(
                            controller: _number,
                            decoration: InputDecoration(
                              labelText: "Nomor Telepon",
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
                            child: Text("Lokasi",style: TextStyle(color: AppColors.primary500,)),
                          ),
                          TextField(
                            controller: _location,
                            decoration: InputDecoration(
                              labelText: "Lokasi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 56,),
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
                              RegisterAuth.instance.number = _number.text;
                              RegisterAuth.instance.location = _location.text;

                              if(RegisterAuth.instance.number.isEmpty || RegisterAuth.instance.location.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data tidak boleh kosong",
                                  style: TextStyle(color: AppColors.grayscale50,fontWeight: FontWeight.bold),),
                                  backgroundColor: AppColors.primary500,));
                              }else{
                                RegisterAuth.instance.register2();
                              }
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
                            child: Text("Kembali",style: TextStyle(fontWeight: FontWeight.bold),)),
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
