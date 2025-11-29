import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: SafeArea(child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            //   container status
            Container(
              width: 347,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 28,
                children: [
                  InkWell(
                    onTap: (){

                    },
                    child: Text("Semua",style: TextStyle(
                        color: AppColors.grayscale950,
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),),
                  ),

                  InkWell(
                    onTap: (){

                    },
                    child: Text("Diproses",style: TextStyle(
                        color: AppColors.grayscale950,
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),),
                  ),

                  InkWell(
                    onTap: (){

                    },
                    child: Text("Selesai",style: TextStyle(
                        color: AppColors.grayscale950,
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),),
                  ),

                  InkWell(
                    onTap: (){

                    },
                    child: Text("Dibatalkan",style: TextStyle(
                        color: AppColors.grayscale950,
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),),
                  )
                ],
              ),
            ),

          //   container item
            Container(
              width: 352,
              height: 154,
              color: Colors.blue,
            ),

            Container(
              width: 352,
              height: 154,
              color: Colors.yellow,
            ),

            Container(
              width: 352,
              height: 154,
              color: Colors.green,
            ),
          ],
        )),
      )
    );
  }
}
