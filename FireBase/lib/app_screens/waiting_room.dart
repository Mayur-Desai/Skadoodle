import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './drawing_room.dart';
import './candidates_list.dart';
import '../models/gamer.dart';
import './canvas_widget.dart';
class waitingRoom extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;

  waitingRoom({super.key, required this.roomParticipants,required this.roomId,required this.isAdmin});

  @override
  State<waitingRoom> createState() => _waitingRoomState(roomParticipants,roomId,isAdmin);
}

class _waitingRoomState extends State<waitingRoom> {
   final CollectionReference roomParticipants;
   String roomId;
   bool isAdmin;
  _waitingRoomState(this.roomParticipants,this.roomId,this.isAdmin);
  late CollectionReference points;

  @override
  void initState(){
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
                child: candidateList(),
              )),
              if(isAdmin==true)
                Align(
                  alignment: Alignment.bottomCenter,
                  child:ElevatedButton(
                      onPressed: () async{
                         await roomParticipants.doc("Parameters").update({'isPressed':true});
                         points = FirebaseFirestore.instance.collection('points$roomId');
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => Draw(roomParticipants: roomParticipants,roomId: roomId,points: points,)),
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
      if(check!=null && check.get('isPressed')==true){
        points = FirebaseFirestore.instance.collection('points$roomId');
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Draw(roomParticipants: roomParticipants,roomId: roomId,points: points,),),
        );
      }
    });
  }
  List<Gamer> _GamerlistfromSnapshot(QuerySnapshot? snapshot){
    return snapshot!.docs.where((doc) => doc.id.length>20).map((doc) {
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
