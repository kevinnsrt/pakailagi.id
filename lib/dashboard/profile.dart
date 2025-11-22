import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: SafeArea(child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // container profile
              Container(
                width: 393,
                height: 294,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(),
                        Text("Andreas"),
                        Icon(Icons.edit)
                      ],
                    )
                  ],
                ),
              ),

              //   container pengaturan
              Container(
                width: 393,
                height: 230,
                color: Colors.yellow,
              ),

              //   container informasi
              Container(
                width: 393,
                height: 160,
                color: Colors.green,
              ),
            ],
          ),
        )),
      )
    );
  }
}
