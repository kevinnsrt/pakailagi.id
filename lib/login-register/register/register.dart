import 'package:flutter/material.dart';
import 'package:smooth_transition/smooth_transition.dart';
import 'package:tubes_pm/authentication/register_auth.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/login-register/register/register2.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();


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
                            controller: _name,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            controller: _email,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            controller: _confirmPass,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                              RegisterAuth.instance.username = _name.text;
                              RegisterAuth.instance.email = _email.text;
                              RegisterAuth.instance.password = _pass.text;
                             RegisterAuth.instance.confirmPassword = _confirmPass.text;

                              if(RegisterAuth.instance.username.isEmpty || RegisterAuth.instance.email.isEmpty || RegisterAuth.instance.password.isEmpty || RegisterAuth.instance.confirmPassword.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data tidak boleh kosong",
                                  style: TextStyle(color: AppColors.grayscale50,fontWeight: FontWeight.bold),),
                                  backgroundColor: AppColors.primary500,));

                              } else if(RegisterAuth.instance.password != RegisterAuth.instance.confirmPassword){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password tidak sesuai",
                                    style: TextStyle(color: AppColors.grayscale50,fontWeight: FontWeight.bold),),
                                  backgroundColor: AppColors.primary500,));
                              }
                              else{
                                RegisterAuth.instance.register1();
                               Navigator.push(context, PageTransition(
                                   child: const RegisterPage2(),
                                   type: PageTransitionType.fade,
                                   duration: Duration(milliseconds: 300),
                                 curve: Curves.easeIn,
                               ));
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
