import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skadoodlem/Buttons/startButton.dart';
import 'package:skadoodlem/Pages/GamePlay.dart';
import 'package:flutter/services.dart';

import 'package:skadoodlem/Pages/components/CandidateList.dart';
import 'package:skadoodlem/model/Gamer.dart';
//import './game_play.dart';
class waitingRoom extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  waitingRoom({required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});

  @override
  State<waitingRoom> createState() => _waitingRoomState(roomParticipants,roomId,isAdmin,Name);
}

class _waitingRoomState extends State<waitingRoom> {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  _waitingRoomState(this.roomParticipants,this.roomId,this.isAdmin,this.Name);
  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://dancingmonkey-6e76d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final pointsCollection;
  late int r;

  @override
  void initState(){
    r=new Random().nextInt(8);
    roomParticipants.doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({'img':r});
    if(isAdmin==false){
      shift();
    }
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Gamer>?>.value(
        value: candidates,
        initialData: null,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white54,
            title: Text(roomId,textAlign: TextAlign.center,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 18
            ),),
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.blueGrey,
                  onPressed: (){
                    Navigator.pop(context);
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
                  child:Start(
                    onTap: () async{
                      await roomParticipants.doc("Parameters").update({'isPressed':true});
                      var list = await roomParticipants.doc('Parameters').get();
                      var listp = list.get('pointsList').entries.toList();
                      pointsCollection= database.child('Points/points$roomId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GamePlay(room: roomParticipants, roomId: roomId, pointsCollection: pointsCollection,isAdmin: isAdmin,Name:Name,playerList:listp,r:r)),
                      );
                    },
                  )
                ),
              SizedBox(height: 20,)
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
          name: doc.get('UserName') ?? '',
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