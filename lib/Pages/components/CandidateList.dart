import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:skadoodlem/model/Gamer.dart';
import 'package:skadoodlem/Pages/components/IngameParticipants.dart';
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
        return InGameplayerTile(gamer: candidates[index],iswaiting: iswaiting,roomParticipants: roomParticipants,isAdmin: isAdmin);
      },
    );
    return listview;
  }
}