import 'package:flutter/material.dart';
import 'Buttons/SignUp.dart';
import 'ExtraLogin/googleSignIn.dart';
import 'Buttons/SignIn.dart';


void main()=> runApp(lesgo());

class lesgo extends StatelessWidget {
  lesgo({super.key});

  final usernameController=TextEditingController();
  final passwordController=TextEditingController();

  void SignUserUp()=>{};
  void SignUserIn()=>{};
  void GoogleSigning()=>{};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home:Scaffold(
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

                  hintText: 'Username',
                ),
                controller: usernameController,
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
                  onTap: SignUserUp,
                ),
                SignIn(
                  onTap: SignUserIn,
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

            googleSignIn(
                imagePath: 'images/google.png',
                onTap:GoogleSigning),

                  ]

            ),
      ),
      ),
      )
    );
    throw UnimplementedError();
  }
}
//
