import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 393,
              height: 120,
              color: AppColors.primary500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset('assets/logo_home.png',width: 127,height: 30,),

                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    width: 197,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        SizedBox(
                          width:125,
                          height: 30,
                          child: ElevatedButton(onPressed: (){}, child: Text("Kota Medan",style: TextStyle(color: AppColors.grayscale700),)),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child:  Icon(Icons.notifications,color: Colors.white,),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.favorite_border,color: Colors.white,),
                        ),
                      ],
                    ),
                  )
                ],
              ),

            )
          ],
        )
      ),
    );
  }
}
