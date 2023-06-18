import 'package:flutter/material.dart';
import 'package:wid_learn/services/auth.dart';
import './register.dart';
class Signin extends StatefulWidget{
  @override
   _SiginInState createState() => _SiginInState();
}
class _SiginInState extends State<Signin>{

  final _formkey = GlobalKey<FormState>();
  final  AuthService _auth = AuthService();
  //text field state
  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Container(
            // code for Anonymous login
            // child: ElevatedButton(
            //   child: Text("Enter Room"),
            //   onPressed: () async {
            //     dynamic result = await _auth.signInAnon();
            //     if(result == null){
            //       debugPrint("Error sigining in");
            //     }else{
            //       debugPrint("Signed In");
            //       // debugPrint(result.uid);
            //     }
            //   },
            // ),
            child:Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: 50.0,),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter a username':null,
                    onChanged: (val){
                      setState(() => email=val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    validator: (val) => val!.length<6 ? 'Enter a password 6+ chars long':null,
                    // using for password
                    obscureText: true,
                    onChanged: (val){
                      setState(() => password=val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          dynamic result = await _auth.signinwithEmailandPassword(email, password);
                          if(result==null){
                            setState(() => error='Could not sign in');
                          }
                        }
                      },
                      child: Text("Sign In")
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text("Sign Up")
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