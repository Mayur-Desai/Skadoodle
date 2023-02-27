import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './drawing_room.dart';
import './candidates_list.dart';
import '../models/gamer.dart';
class waitingRoom extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;

  waitingRoom({super.key, required this.roomParticipants,required this.roomId});

  @override
  State<waitingRoom> createState() => _waitingRoomState(roomParticipants,roomId);
}

class _waitingRoomState extends State<waitingRoom> {
   final CollectionReference roomParticipants;
   String roomId;

  _waitingRoomState(this.roomParticipants,this.roomId);

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
          body: Container(
            child: candidateList()
          ),
        )
    );
  }
  List<Gamer> _GamerlistfromSnapshot(QuerySnapshot? snapshot){
    return snapshot!.docs.map((doc) {
      return Gamer(
          name: doc.get('Name') ?? '',
          points: doc.get('points') ?? 0,
          rank: doc.get('rank') ?? 0
      );
    }).toList();
  }
   Stream<List<Gamer>> get candidates{
     return roomParticipants.snapshots()
         .map(_GamerlistfromSnapshot);
   }
}
