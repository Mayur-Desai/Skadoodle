import 'package:flutter/material.dart';
import '../services/auth.dart';
class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String username='';
  String password='';
  String error='';
  String email='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Container(
            child:Form(
              key: _formKey ,
              child: Column(
                children: [
                  SizedBox(height: 50.0,),
                  TextFormField(
                    validator: (val)=> val!.isEmpty? 'Enter a username':null,
                    onChanged: (val){
                      setState(() => email=val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    // using for password
                    obscureText: true,
                    validator: (val)=> val!.length < 6? 'Enter a password 6+ chars long':null,
                    onChanged: (val){
                      setState(() => password=val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    // using for email
                    validator: (val)=> val!.isEmpty? 'Enter a email':null,
                    onChanged: (val){
                      setState(() => username=val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          dynamic result = await _auth.registerwithEmailandPassword(email, password, username);
                          if(result==null){
                            setState(()=> error = "plz enter correct details");
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Register")
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
