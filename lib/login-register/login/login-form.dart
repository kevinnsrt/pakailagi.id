import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/login.dart';
import 'package:tubes_pm/colors/colors.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  List<bool> toggleList = [true];

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
          title: Text("Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          child: SafeArea(child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 362,
                  height: 90,
                  child: Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/register_logo.png'),
                      Text("Selamat Datang",style: TextStyle(
                          color: AppColors.primary700,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),)
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
                            height: 25,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          SizedBox(
                            width:355,
                            height: 25,
                            child: Text("Password",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
                          ),
                          TextField(
                            controller: _pass,
                            obscureText: toggleList[0],
                            decoration: InputDecoration(
                              suffixIcon:  GestureDetector(
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

                      SizedBox(
                        height: 12,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Text("Lupa Password ?",
                            style: TextStyle(color: AppColors.primary700,fontSize: 12,fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        width: 361,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (){
                          LoginAuth.instance.email = _email.text;
                          LoginAuth.instance.password = _pass.text;

                          LoginAuth.instance.login1(context);
                          }, child: Text("Masuk",
                          style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.grayscale50,fontSize: 16),
                        ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              elevation: 6
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: 304,
                        height: 22,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Container(
                              width: 85,
                              height: 1,
                              color: AppColors.grayscale500,
                            ),

                            Text("atau login dengan",style: TextStyle(color: AppColors.grayscale500,fontSize: 14),),

                            Container(
                              width: 85,
                              height: 1,
                              color: AppColors.grayscale500,
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                Container(
                  width: 314,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      GestureDetector(
                        child: Image.asset('assets/google.png'),
                      ),

                      GestureDetector(
                        child: Image.asset('assets/apple.png'),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                Container(
                  width: 180,
                  height: 22,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Text("Belum punya akun?",style: TextStyle(color: AppColors.grayscale950
                          ,fontSize: 13),),
                      Text("Sign Up",style: TextStyle(color: AppColors.primary700,fontWeight: FontWeight.bold,fontSize: 13),)
                    ],
                  ),
                ),

                SizedBox(
                  height: 104,
                ),

                Container(
                  width: 215,
                  height: 42,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("By signing up, you agreed to our",style: TextStyle(color: AppColors.grayscale500,fontSize: 12),),
                      Text("Privacy Policy and Terms of Service",style: TextStyle(color: AppColors.primary700,fontSize: 12),)
                    ],
                  ),
                ),
              ],
            ),
          )),
        )
    );
  }
}
