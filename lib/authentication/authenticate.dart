import 'package:flutter/material.dart';
import './sign_in.dart';
class authenticate extends StatefulWidget{
  @override
  _authenticate createState() => _authenticate();
}
class _authenticate extends State<authenticate>{
  bool showSignIn = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Signin(),
    );
  }
}