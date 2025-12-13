import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Profil"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            //   avatar
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    SizedBox(
                      width:120,
                      height: 120,
                      child: CircleAvatar(
                        child: Icon(Icons.person,size: 50,),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 6,
                      child: SizedBox(
                        width: 33,
                        height: 33,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: CircleBorder(),
                            backgroundColor: Colors.white
                          ),
                          onPressed: () {},
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.grayscale500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            // gap
              SizedBox(
                height: 48,
              ),

            //   data diri
              Container(
                width: 365,
                height: 248,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text("Nama Lengkap"),
                    _textField(),
                    Text("Email"),
                    _textField(),
                    Text("No.Handphone"),
                    _textField()
                  ],
                ),
              ),
            // gap
              SizedBox(
                height: 32,
              ),

            //   Button Simpan
              Container(
                width: 365,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      elevation: 6
                    ),
                    onPressed: (){}, child: Text("Simpan",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),)),
              )
            ],
          ),
        )
      ),
    );
  }
}

Widget _textField(){
  return TextField(
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        )
    ),
  );
}
