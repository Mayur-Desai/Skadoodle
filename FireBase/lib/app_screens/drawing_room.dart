import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import './game_settings.dart';
import './waiting_room.dart';

class room extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => roomLogin();
}
class roomLogin extends State<room>{

  // used for signout function in the auth file
  final AuthService _auth = AuthService();

  // used to create a private room
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // instance to create a new collection
  late CollectionReference roomParticipants;

  // used to select a unique room ID
  Set roomId ={};
  Random random = new Random();
  String? Id;

  // keeping track of the room admin
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().player,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          actions: [
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text("Logout"),
                onPressed: () async{
                  await _auth.signout();
                },
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Text("Create a Private Room"),
                SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      // debugPrint("Till here");
                      int randomNumber;
                      do{
                        randomNumber = 100000 + random.nextInt(1000000 - 100000);
                      }while(roomId.contains(randomNumber));
                      roomId.add(randomNumber);
                      // debugPrint("Till here");
                      roomParticipants = FirebaseFirestore.instance.collection(randomNumber.toString());
                      var userId = auth.currentUser!.uid;
                      var userData = await firestore.collection('Players').doc(userId).get();
                      await roomParticipants.doc(userId).set(userData.data());
                      await roomParticipants.doc("Parameters").set({
                        'isPressed':false,
                        'rounds':0,
                        'duration':0,
                        'word_count':3,
                        'Hints':2
                      });
                      debugPrint(randomNumber.toString());
                      isAdmin=true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameSettings(roomParticipants: roomParticipants,roomId: randomNumber.toString(),isAdmin: isAdmin)),
                      );
                    },
                    child: Text("CREATE")
                ),
                SizedBox(height: 20.0,),
                Text("Enter a Private Room"),
                SizedBox(height: 20.0,),
                TextFormField(
                  validator: (val)=> val!.length<6 ? 'Enter a Valid Id':null,
                  onChanged: (val){
                    setState(()=> Id = val);
                    debugPrint(Id.toString());
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      debugPrint("Till here");
                      debugPrint(Id);
                      roomParticipants = FirebaseFirestore.instance.collection(Id!);
                      var userId = auth.currentUser!.uid;
                      var userData = await firestore.collection('Players').doc(userId).get();
                      await roomParticipants.doc(userId).set(userData.data());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: Id!,isAdmin: isAdmin,)),
                      );
                    },
                    child: Text("Enter")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}