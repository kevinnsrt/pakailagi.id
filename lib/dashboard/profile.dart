import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/user-data.dart';
import 'package:tubes_pm/colors/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Map<String, dynamic>? userData;
  Future<void> userdata() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await ApiServiceLogin.loginWithUid(uid: user.uid);
      setState(() {
        userData = data;
        print(data);
      });
    }
  }
  @override

  void initState() {
    super.initState();
    userdata();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: SafeArea(child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // container profile
              Container(
                width: 393,
                height: 194,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 393,
                      height: 74,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 72,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: CircleAvatar(
                                  child: Icon(Icons.person,size: 32,),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData?["name"] ?? "Loading...",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.grayscale950
                                    ),
                                  ),
                                  Text(
                                    userData?["number"] ?? "Loading...",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary800
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      width: 393,
                      height: 62,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 63,
                            child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9)
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 6,
                                    foregroundColor: AppColors.primary700
                                  )
                                ,onPressed: (){}, child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.contacts),
                                    Text("Whatsapp"),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                              ],
                            )),
                          ),

                          SizedBox(
                            width: 180,
                            height: 63,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(9)
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 6,
                                  foregroundColor: AppColors.primary700
                                )
                                ,onPressed: (){}, child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(Icons.favorite_border_outlined),
                                    Text("Favorit Saya",maxLines: 2,),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                              ],
                            )),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 393,
                height: 10,
                color: AppColors.grayscale300,
              ),

              //   container pengaturan
              Container(
                width: 393,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 6,
                  children: [

                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 393,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Text("Pengaturan",style: TextStyle(color: AppColors.grayscale950,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Container(
                      width: 341,
                      height: 53,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock,color: AppColors.grayscale400,),
                          Text("Edit Password"),
                          SizedBox(width: 150,),
                          Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                        ],
                      ),
                    ),

                    Container(
                      width: 341,
                      height: 1,
                      color: AppColors.grayscale400,
                    ),

                    Container(
                      width: 341,
                      height: 53,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(Icons.location_on,color: AppColors.grayscale400,),
                          Text("Lokasi Anda"),
                          SizedBox(width: 165,),
                          Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: 393,
                height: 10,
                color: AppColors.grayscale300,
              ),

              //   container informasi
              Container(
                width: 393,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 6,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 393,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Text("Informasi",style: TextStyle(color: AppColors.grayscale950,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Container(
                      width: 341,
                      height: 53,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.question_mark,color: AppColors.grayscale400,),
                          Text("FAQ"),
                          SizedBox(width: 220,),
                          Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                        ],
                      ),
                    ),

                    Container(
                      width: 341,
                      height: 1,
                      color: AppColors.grayscale400,
                    ),

                    Container(
                      width: 341,
                      height: 53,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat,color: AppColors.grayscale400,),
                          Text("Chat Bantuan"),
                          SizedBox(width: 150,),
                          Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: 393,
                height: 10,
                color: AppColors.grayscale300,
              ),


              // container logout
              Container(
                width: 393,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 6,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 393,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Text("Logout",style: TextStyle(color: AppColors.grayscale950,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                   GestureDetector(
                     onTap: (){
                       _signOut();
                     },
                     child:  Container(
                       width: 341,
                       height: 53,
                       child: Row(
                         spacing: 8,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.logout,color: AppColors.grayscale400,),
                           Text("Logout"),
                           SizedBox(width: 190,),
                           Icon(Icons.arrow_forward_ios_outlined,color: AppColors.grayscale400,)
                         ],
                       ),
                     ),
                   )

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
