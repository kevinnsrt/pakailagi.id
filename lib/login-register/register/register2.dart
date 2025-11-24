import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/authGate.dart';
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
                      Text("Lengkapi Data",textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.primary700),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                Container(
                  width: 362,
                  height: 198,
                  child: Column(
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          SizedBox(
                          width:355,
                            height: 20,
                            child: Text("Nomor Telepon",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
                          ),
                          TextField(
                            controller: _number,
                            decoration: InputDecoration(
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
                            child: Text("Lokasi",style: TextStyle(color: AppColors.grayscale800,fontSize: 12),),
                          ),
                          TextField(
                            controller: _location,
                            decoration: InputDecoration(
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


                Container(
                  width: 362,
                  height: 48,
                  child: ElevatedButton(
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
                      RegisterAuth.instance.register2(context);
                    }
                  }, child: Text("Selanjutnya",style: TextStyle(fontWeight: FontWeight.bold),)),
                ),

                SizedBox(height: 28,),

              ],
            )),
      ),
    )
    );
  }
}
