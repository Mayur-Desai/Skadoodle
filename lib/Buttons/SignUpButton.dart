import 'package:flutter/material.dart';

class SignUp extends StatelessWidget{

  final Function()? onTap;

  const SignUp({super.key, this.onTap});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius:BorderRadius.circular(35),
        ),
        child:const Center(child: Text(
            "    Sign up    ",
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