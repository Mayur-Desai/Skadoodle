import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wid_learn/app_screens/player_list.dart';
import '../models/gamer.dart';
import './ingame_participants.dart';
class candidateList extends StatefulWidget {
  bool iswaiting;
  bool isAdmin;
  final CollectionReference roomParticipants;
  candidateList({required this.iswaiting,required this.isAdmin,required this.roomParticipants});
  @override
  State<candidateList> createState() => _candidateListState(iswaiting: iswaiting,isAdmin: isAdmin,roomParticipants: roomParticipants);
}

class _candidateListState extends State<candidateList> {
  bool iswaiting;
  bool isAdmin;
  final CollectionReference roomParticipants;
  _candidateListState({required this.iswaiting,required this.isAdmin,required this.roomParticipants});
  @override
  Widget build(BuildContext context) {
    final candidates = Provider.of<List<Gamer>?>(context) ?? [];
    return getPlayerlist(candidates);
  }
  Widget getPlayerlist(candidates){
    var listview = ListView.builder(
      itemCount: candidates.length,
      itemBuilder: (context,index){
        if(iswaiting){
          return playerTile(gamer: candidates[index],isAdmin: isAdmin,roomParticipants: roomParticipants);
        }
        else{
          return InGameplayerTile(gamer: candidates[index],isAdmin: isAdmin,roomParticipants: roomParticipants);
        }
      },
    );
    return listview;
  }
}
