import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './canvas_widget.dart';
import './drawing_room.dart';
import './candidates_list.dart';
import '../models/gamer.dart';
import './game_play.dart';
class waitingRoom extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  waitingRoom({super.key, required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});

  @override
  State<waitingRoom> createState() => _waitingRoomState(roomParticipants,roomId,isAdmin,Name);
}

class _waitingRoomState extends State<waitingRoom> {
   final CollectionReference roomParticipants;
   String roomId;
   bool isAdmin;
   String Name;
  _waitingRoomState(this.roomParticipants,this.roomId,this.isAdmin,this.Name);
   DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final pointsCollection;
  late int r;

  @override
  void initState(){
    r=new Random().nextInt(8);
    roomParticipants.doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({'img':r});
    if(isAdmin==false){
      shift();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Gamer>?>.value(
      value: candidates,
        initialData: null,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white54,
            title: Text(roomId),
            actions: [
              TextButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text("Exit"),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Container(
                child: candidateList(iswaiting:true,isAdmin:isAdmin,roomParticipants:roomParticipants,),
              )),
              if(isAdmin==true)
                Align(
                  alignment: Alignment.bottomCenter,
                  child:ElevatedButton(
                      onPressed: () async{
                         await roomParticipants.doc("Parameters").update({'isPressed':true});
                         var list = await roomParticipants.doc('Parameters').get();
                         var listp = list.get('pointsList').entries.toList();
                         pointsCollection= database.child('Points/points$roomId');
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => GamePlay(room: roomParticipants, roomId: roomId, pointsCollection: pointsCollection,isAdmin: isAdmin,Name:Name,playerList:listp,r:r)),
                         );
                    },
                    child: Text("START"),
                  ),
                )
            ],
          ),
        )
    );
  }
  void shift(){
    roomParticipants.snapshots().listen((snapshot) {
      var check = snapshot.docs.firstWhere((doc) => doc.id=="Parameters");
      var l = snapshot.docs.length;
      if(l==1){
        deleteCollection(roomId);
      }
      if(check!=null && check.get('isPressed')==true){
        pointsCollection= database.child('Points/points$roomId');
        var List = check.get('pointsList').entries.toList();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GamePlay(room: roomParticipants, roomId: roomId, pointsCollection: pointsCollection,isAdmin: isAdmin,Name:Name,playerList:List,r:r)),
        );
      }
    });
  }
  List<Gamer> _GamerlistfromSnapshot(QuerySnapshot? snapshot){
    return snapshot!.docs.where((doc) => doc.id.length>20).map((doc) {
        return Gamer(
            name: doc.get('Name') ?? '',
            points: 0,
            rank: 0,
            index: doc.get('img')??0,
            guessed:false
        );
    }).toList();
  }
   Stream<List<Gamer>> get candidates{
     return roomParticipants.snapshots()
         .map(_GamerlistfromSnapshot);
   }
   void deleteCollection(String collectionPath) async {
     CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionPath);
     QuerySnapshot querySnapshot = await collectionRef.get();
     for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
       await docSnapshot.reference.delete();
     }
     await collectionRef.parent!.delete();
   }
}
