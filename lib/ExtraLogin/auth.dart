import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skadoodlem/ExtraLogin/loginOrRegiter.dart';
import 'package:skadoodlem/Pages/LoginIn.dart';
import 'package:skadoodlem/Pages/HomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key})  ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData) {
              return homePage(); // the crete room
            }

            else{
              return const LoginOrRegister();
            }


          },
        ),
      ),
    );
  }
}
