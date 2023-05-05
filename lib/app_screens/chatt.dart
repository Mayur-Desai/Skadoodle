import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  String roomId;
  CustomData({required this.roomId});
  @override
  State<CustomData> createState() => _CustomDataState(roomId: roomId);
}
class _CustomDataState extends State<CustomData> {
  String roomId;
  _CustomDataState({required this.roomId});

  late Map<String,dynamic> ff;
  List<MapEntry<String,dynamic>> cd =[];

  final UserName="Anish";
  final msg=TextEditingController();
  bool isTextInputReadOnly=false;
  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final chats;
  late Map<String,dynamic> ch;

  @override
  void initState(){
    chats = database.child('chats$roomId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
            color: Colors.grey,
            child: StreamBuilder<DataSnapshot>(
            stream: chats.onValue.map((event) => event.snapshot).cast<DataSnapshot>(),
            builder: (context,snapshot){
            if(!snapshot.hasData){
                debugPrint("No data");
                return getLongListView(cd);
            }
            String jsonStr = jsonEncode(snapshot.data!.value);
            if(jsonStr!='null'){
                ch = jsonDecode(jsonStr);
                cd = (ch as Map<String,dynamic>).entries.map((e) {
                    return MapEntry(e.key, e.value);
                }).toList();
            }
            return getLongListView(cd);
            },
            )
      ),
    );
  }
  Widget getLongListView(var chats){
    var listitems=chats;
    var listview=ListView.builder(
        itemCount: listitems.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(listitems[index].key),
            trailing: Text(listitems[index].value),
          );
        }
    );
    return listview;
  }
}
