import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skadoodlem/Buttons/CreateRoomButtom.dart';
import 'package:skadoodlem/Pages/gameSettings.dart';
import 'dart:math';
import 'package:skadoodlem/model/user_model.dart';
import 'package:skadoodlem/Pages/WaitingRoom.dart';






class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Random random = new Random();

  Set roomId={};
  late UserModel userModel;
  bool isAdmin = false;
  late String Id;


  late CollectionReference roomParticipants;

  void getUserData() async{
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      userModel = UserModel.fromDocument(userData);

    });
  }



  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void JoinRoom() async{
    Id=CodeController.text;
    debugPrint(Id);
    roomParticipants = FirebaseFirestore.instance.collection(Id!);
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    await roomParticipants.doc(userId).set(userData.data());
    var sd = await roomParticipants.doc('Parameters').get();
    Map<String,dynamic> data = sd.get('pointsList');
    String name=userData.get('UserName');
    data[name]=[0,0];
    await roomParticipants.doc('Parameters').update({'pointsList':data});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: Id!,isAdmin: isAdmin,Name:name)),
    );
  }

  void CreateRoom() async{
    int? randomNumber;
    do{
      randomNumber = 100000 + random.nextInt(1000000 - 100000);
    }while(roomId.contains(randomNumber));
    roomId.add(randomNumber);
    // debugPrint("Till here");
    roomParticipants = FirebaseFirestore.instance.collection(randomNumber.toString());

    var userId = FirebaseAuth.instance.currentUser!.uid;
    var userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    await roomParticipants.doc(userId).set(userData.data());
    String name=userData.get('UserName');
    // debugPrint(userData.get('UserName'));
    Map<String,dynamic> data = {name:0};
    await roomParticipants.doc("Parameters").set({
      'isPressed':false,
      'rounds':0,
      'duration':0,
      'word_count':3,
      'Hints':2,
      'word_choosen':'',
      'pointsList':data
    });
    roomParticipants.doc(userId).update({'isDrawing':true});
    debugPrint(randomNumber.toString());
    isAdmin=true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameSettings(roomParticipants: roomParticipants,roomId: randomNumber.toString(),isAdmin: isAdmin,Name:name)),
    );

   }


  //

  void initState(){
    getUserData();
  }



  final CodeController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        leading:const Icon(Icons.menu,color: Colors.black54,),
        title:Text(
          userModel.UserName,
            style: TextStyle(
              color:Colors.black54,
              fontSize: 26,
            )
        ),


        backgroundColor:Colors.transparent,
        actions: [
          GestureDetector(
            onTap:signUserOut,
            child: Container(
              // child: IconButton(onPressed:(){}, icon: const Image(image: AssetImage('images/mik.gif')),),
              child: Image.asset('images/mik.gif',height: 125.0, width: 125.0,),
            ),
          )
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
                            'images/itachi.png',
                            width: 100,
                            height: 80,)
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
                  padding: const EdgeInsets.symmetric(horizontal:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  [
                      ClipRRect(
                          child: Image.asset(
                            'images/demonslay.png',
                            width: 150,
                            height: 160, )
                      ),

                      const SizedBox(width: 0,),

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
                                      keyboardType: TextInputType.number,
                                      controller: CodeController,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],


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
