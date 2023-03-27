import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skadoodlem/Buttons/SignInButton.dart';
import 'package:skadoodlem/Buttons/SignUpButton.dart';
import 'package:skadoodlem/Buttons/googleSignInButton.dart';
import 'package:skadoodlem/ExtraLogin/GoogleService.dart';
import 'package:skadoodlem/Pages/components/LoginAuth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginIn extends StatefulWidget {
  final Function()? togg;
  LoginIn({super.key, required this.togg});

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {


  final emailController=TextEditingController();
  final passwordController=TextEditingController();


// void SignUserIn() async{
//   try{
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text);
//
//   } on FirebaseAuthException catch(e){
//     if(e.code=='user-not-found'){
//       invalidEmailMsg();
//       // SignUserUp();
//     }else if(e.code=='wrong-password'){
//       wrongPassMsg();
//     }
//   }
//
//
// }
//
// void invalidEmailMsg(){
//   showDialog(
//       context:context,
//       builder: (context){
//     return const AlertDialog(
//       backgroundColor: Colors.deepPurple,
//       title:Text(
//         'No Account Linked To Email',
//         style: TextStyle(
//           color: Colors.white,
//         ),
//
//         ) ,
//       );
//     },
//   );
// }
//
// void wrongPassMsg(){
//   showDialog(
//     context:context,
//     builder: (context){
//       return const AlertDialog(
//         backgroundColor: Colors.deepPurple,
//         title:Text('Wrong Password',
//           style: TextStyle(
//           color: Colors.white,
//           )
//         ) ,
//       );
//     },
//   );
// }




  @override
  Widget build(BuildContext context) {
    LoginAuthProvider loginAuthProvider =
    Provider.of<LoginAuthProvider>(context);
    return Scaffold(
          resizeToAvoidBottomInset : false,
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child:Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    const SizedBox(height:10),

                    Image.asset('images/trollFace.png',width: 300,height: 250,),
                    const SizedBox(height:5),
                    Text(
                        'Skadoodle',
                        style: TextStyle(
                          color:Colors.red[300],
                          fontSize: 70,
                          fontFamily: 'Pacifico',
                        )
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown)
                          ),
                          fillColor: Colors.white54,
                          filled: true,

                          hintText: 'Email',
                        ),
                        controller: emailController,
                        obscureText: false,
                      ),
                    ),


                    const SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown)
                          ),

                          fillColor: Colors.white54,
                          filled: true,
                          hintText: 'Password',

                        ),
                        controller: passwordController,
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:25),
                          child: Text(
                            'Forgot Password?',
                            style:TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),

                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignUp(
                          onTap: widget.togg,

                        ),
                        SignIn(
                          xd: () {
                            loginAuthProvider.loginPageVaidation(
                              emailAdress: emailController,
                              password: passwordController,
                              context: context,
                            );
                          },

                        )
                      ],
                    ),

                    const SizedBox(height: 30,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25),
                      child: Row(
                        children: const [
                          Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.brown,
                              )
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Or Continue with',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),

                          Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.brown,
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    googleSignInB(
                        imagePath: 'images/google.png',
                        onTap:()async{
                          final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();
                          final GoogleSignInAuthentication gAuth = await gUser!.authentication;

                          final credential =GoogleAuthProvider.credential(
                            accessToken: gAuth.accessToken,
                            idToken: gAuth.idToken,
                          );
                          return await FirebaseAuth.instance.signInWithCredential(credential);

                          },
                    )


                  ]

              ),
            ),
          ),
        );
  }
}

