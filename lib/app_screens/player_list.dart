import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gamer.dart';
import '../models/User.dart';

class playerTile extends StatelessWidget {
  final Gamer gamer;
  bool isAdmin;
  final CollectionReference roomParticipants;
  playerTile({required this.gamer,required this.isAdmin,required this.roomParticipants});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
            ),
            title: Text(gamer.name),
            subtitle: Text(gamer.points.toString()),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: ()  {
                roomParticipants.doc(user?.uid).delete();
                if(isAdmin==true){
                  Navigator.pop(context);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
    );
  }
}
