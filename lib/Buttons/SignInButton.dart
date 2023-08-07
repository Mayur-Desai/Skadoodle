import 'package:flutter/material.dart';

class SignIn extends StatelessWidget{

  final Function()? xd;

  const SignIn({super.key, this.xd});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:xd,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:BorderRadius.circular(35),
        ),
        child:const Center(child: Text(
            "    Sign in    ",
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