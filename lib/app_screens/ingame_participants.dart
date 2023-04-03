import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gamer.dart';
import '../models/User.dart';

class InGameplayerTile extends StatelessWidget {
  final Gamer gamer;
  bool isAdmin;
  final CollectionReference roomParticipants;
  InGameplayerTile({required this.gamer,required this.isAdmin,required this.roomParticipants});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return Padding(
      padding: EdgeInsets.only(top: 0.0),
      child: Card(
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(gamer.name),
          subtitle: Text(gamer.points.toString()),
          trailing: Text(gamer.rank.toString()),
        ),
      ),
    );
  }
}
