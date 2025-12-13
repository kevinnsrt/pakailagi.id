import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Kata Sandi"),
      ),
      body: Center(
        child: Column(
          children: [
            //gap
            SizedBox(
              height: 12,
            ),
            // form
            Container(
              width: 365,
              height: 248,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  _text("Kata sandi saat ini"),
                  _textField(),
                  _text("Kata sandi baru"),
                  _textField(),
                  _text("Konfirmasi kata sandi baru"),
                  _textField()
                ],
              ),
            ),

          //   gap
            SizedBox(height: 32,),

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
      ),
    );
  }
}

// text field
Widget _textField(){
  return TextField(
    obscureText: true,
    decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
        )
    ),
  );
}

// text
Widget _text (String title){
  return Text(title);
}
