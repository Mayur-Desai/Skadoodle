import 'package:flutter/material.dart';
import 'package:skadoodlem/Pages/LoginIn.dart';

import '../Pages/signUp.dart';

class LoginOrRegister extends StatefulWidget {


  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool ShowLoginPage=true;

  void toggle(){
    setState(() {
      ShowLoginPage=!ShowLoginPage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(ShowLoginPage) {
      return LoginIn(
        togg: toggle,
      );
    }
    else{
      return signUp(
        togg:toggle,
      );
    }
  }
}
