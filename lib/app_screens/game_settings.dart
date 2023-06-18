import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './waiting_room.dart';
class GameSettings extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  GameSettings({required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});
  @override
  State<GameSettings> createState() => _GameSettingsState(roomParticipants: roomParticipants,roomId: roomId,isAdmin: isAdmin,Name: Name);
}
class _GameSettingsState extends State<GameSettings> {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;

  _GameSettingsState({required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});

  var rounds=0;
  var duration=0;
  var word_count=3;
  var hints=2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (val){
              rounds=int.tryParse(val) ?? 0;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (val){
              duration=int.tryParse(val) ?? 0;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (val){
              word_count=int.tryParse(val) ?? 0;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (val){
              hints=int.tryParse(val) ?? 0;
            },
          ),
          ElevatedButton(
              onPressed:()async{
                await roomParticipants.doc("Parameters").update({
                  'rounds':rounds,
                  'duration':duration,
                  'word_count':word_count,
                  'Hints':hints
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: roomId,isAdmin: isAdmin,Name:Name)),
                );
              },
              child: Text("CREATE")
          )
        ],
      ),
    );
  }
}
