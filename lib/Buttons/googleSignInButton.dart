import 'package:flutter/material.dart';

class googleSignInB extends StatelessWidget{

  final Function()? onTap;

  final String imagePath;

  const googleSignInB({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
         child: Image.asset(
           imagePath,
           width: 200,
           height: 100,
         ),
      ),
    );
    throw UnimplementedError();
  }

}
