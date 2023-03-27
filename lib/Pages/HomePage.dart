import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skadoodlem/Buttons/CreateRoomButtom.dart';


class homePage extends StatelessWidget {
  homePage({Key? key}) : super(key: key);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  void JoinRoom(){}
  void CreateRoom(){}
  final CodeController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
        backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title:Text(
          'Mayur',
            style: TextStyle(
              color:Colors.red[400],
              fontSize: 26,
            )
        ),

        backgroundColor:Colors.brown[400] ,
        actions: [
          IconButton(onPressed: signUserOut,
              icon: const Icon(Icons.login_rounded)),
        ],
      ),
      body: SafeArea(
        child:Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                const SizedBox(height:200),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'images/eren2.jpg',
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,)
                      ),

                      const SizedBox(width: 30,),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:  [
                            Text('HOST',
                                style: TextStyle(
                                  color:Colors.blueGrey[400],
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )
                            ),


                            const Divider(
                                    thickness: 1,
                                    color: Colors.brown,
                            ),

                            CreateRoomButton(
                               onTap: CreateRoom,
                            )
                          ],
                        ),
                      )


                    ],
                  ),
                ),

                const SizedBox(height: 200,),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            'images/squad2.jpg',
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,)
                      ),

                      const SizedBox(width: 30,),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:  [
                            Text('JOIN',
                                style: TextStyle(
                                  color:Colors.blueGrey[400],
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )
                            ),


                            const Divider(
                              thickness: 1,
                              color: Colors.brown,
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  const SizedBox(width: 10,),
                                
                                  Expanded(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.all(9),
                                        enabledBorder:  OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: const BorderSide(color: Colors.white)
                                        ),
                                        focusedBorder:  OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(color: Colors.blueGrey)
                                        ),

                                        fillColor: Colors.white54,
                                        filled: true,
                                        hintText: 'Enter Code'

                                      ),
                                      controller: CodeController,


                                    ),
                                  ),


                                  IconButton(onPressed: JoinRoom,
                                      icon: const Icon(Icons.arrow_circle_right_outlined )),
                                ]

                            )
                          ],
                        ),
                      )


                    ],
                  ),
                )
              ]
          ),
        ),
      )

    );
  }
}
