import 'package:flutter/material.dart';
class select extends StatefulWidget {
  const select({Key? key}) : super(key: key);

  @override
  State<select> createState() => _selectState();
}

class _selectState extends State<select> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child:Center(
            child:
            Container(
              child: Text(
        "Passwords Don't Match",
        style: TextStyle(
        color: Colors.black,
    ),
            ),
          )
        )
        )
    );

  }
}
