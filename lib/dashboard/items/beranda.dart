import 'package:flutter/material.dart';

class ItemBeranda extends StatefulWidget {
  const ItemBeranda({super.key});

  @override
  State<ItemBeranda> createState() => _ItemBerandaState();
}

class _ItemBerandaState extends State<ItemBeranda> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          width: 154,
          height: 236,
          child: Card(
            color: Colors.green,
          ),
        ),

        Container(
          width: 154,
          height: 236,
          child: Card(
            color: Colors.blue,
          ),
        ),

        Container(
          width: 154,
          height: 236,
          child: Card(
            color: Colors.yellow,
          ),
        ),

        Container(
          width: 154,
          height: 236,
          child: Card(
            color: Colors.red,
          ),
        )
      ],
    );
  }
}
