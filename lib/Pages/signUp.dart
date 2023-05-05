import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wid_learn/Buttons/SignUpButton.dart';
import 'package:wid_learn/ExtraLogin/GoogleService.dart';
import 'package:wid_learn/Pages/LoginIn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wid_learn/Pages/components/SignUpAuth.dart';
import '../Buttons/googleSignInButton.dart';
import 'package:responsive_framework/responsive_framework.dart';

class signUp extends StatefulWidget {

  final Function()? togg;
  signUp({Key? key, required this.togg}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {


  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final username=TextEditingController();
  final confirmpasswordController=TextEditingController();

  UserCredential? userCredential;

  // void loginback()=>{
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginIn()),
  //   )
  // };

  // void SignUpFirebase() async {
  //   try {
  //     if (passwordController.text == confirmpasswordController.text) {
  //       userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text);
  //       FirebaseFirestore.instance.collection("players").doc(userCredential!.user!.uid).set({
  //         "UserID":userCredential!.user!.uid,
  //         "userName":username.text,
  //         "emailAddress": emailController.text,
  //         "password":passwordController.text,
  //
  //       });







  //     }else{
  //       PassMisMatch;
  //     }
  //   }
  //   on FirebaseAuthException catch (e) {}
  //
  // }

  void PassMisMatch(){
    showDialog(
      barrierDismissible:false,
      context:context,
      builder: (context){
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title:Text(
            "Passwords Don't Match",
            style: TextStyle(
              color: Colors.white,
            ),

          ) ,
        );
      },
    );
  }

  // void googleInFirebase(){
  //   GoogleService().SignInGoogle;
  // }



  @override
  Widget build(BuildContext context) {
    SignupAuthProvider signupAuthProvider =
    Provider.of<SignupAuthProvider>(context);
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        // body: Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("images/bgImg.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
          body: SingleChildScrollView(
            child: SafeArea(
                child:Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          const SizedBox(height:10),

                          Image.asset('images/welcome.png',width: 300,height: 250,),

                          const SizedBox(height:0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                hintText: 'User Name',

                              ),
                              controller: username,
                              obscureText: false,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                hintText: 'Confirm Password',

                              ),
                              controller: confirmpasswordController,
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 20),


                          SignUp(
                            onTap:() {
                          signupAuthProvider.signupVaidation(
                          fullName: username,
                          context: context,
                          emailAdress: emailController,
                          password: passwordController,
                          ConfirmPassword: confirmpasswordController,
                          );
                          },
                          ),

                          const SizedBox(height: 40),

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
                          ),

                          const SizedBox(height: 20),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color:Colors.grey[700],
                                  ),
                              ),
                              const SizedBox(width:4),
                              GestureDetector(
                                onTap: widget.togg,
                                child:const Text(
                                  'Login Now',
                                  style:TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              )



                            ],
                          ),






                        ]
                    )
                )
            ),
          ),
      )
    );
  }
}
