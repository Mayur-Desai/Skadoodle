import 'package:flutter/material.dart';

class CreateRoomButton extends StatelessWidget{

  final Function()? onTap;

  const CreateRoomButton({super.key, this.onTap});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[300],
          borderRadius:BorderRadius.circular(35),
        ),
        child:const Center(child: Text(
            "    Create Room    ",
            style:TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
            )
        )
        ),
      ),
    );
    throw UnimplementedError();
  }

}