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

  List<bool> toggleList = [true, true];

  void _toggle(int index) {
    setState(() {
      toggleList[index] = !toggleList[index];
      // _isToggle = !_isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text("Sign Up",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 358,
                  height: 104,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Image.asset('assets/register_logo.png'),
                      Text("Buat Akun Baru",textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.primary700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 365,
                  height: 344,
                  child: Column(
                    children: [
                      Column(
                        spacing: 10,
                        children: [
                          SizedBox(
                          width:360,
                            height: 20,
                            child: Text("Nama Lengkap",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
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
                            child: Text("Email",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
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
                            child: Text("Kata Sandi",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
                          ),
                          TextField(
                            controller: _pass,
                            obscureText: toggleList[0],
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  _toggle(0);
                                },
                                child: Icon(toggleList[0] ? Icons.visibility_off : Icons.visibility,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            child: Text("Konfirmasi Kata Sandi",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
                          ),
                          TextField(
                            controller: _confirmPass,
                            obscureText: toggleList[1],
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  _toggle(1);
                                },
                                child: Icon(toggleList[1] ? Icons.visibility_off : Icons.visibility,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.primary500
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
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
                  height: 48,
                  child: ElevatedButton(
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
                  }, child: Text("Selanjutnya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                ),

                SizedBox(
                  height: 32,
                ),

                Container(
                  width: 181,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text("Sudah Punya Akun?"),
                      Text("Sign In",style: TextStyle(color: AppColors.primary800,fontWeight: FontWeight.bold),),
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
