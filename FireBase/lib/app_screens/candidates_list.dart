import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/gamer.dart';
class candidateList extends StatefulWidget {
  @override
  State<candidateList> createState() => _candidateListState();
}

class _candidateListState extends State<candidateList> {
  @override
  Widget build(BuildContext context) {
    final candidates = Provider.of<List<Gamer>?>(context);
    candidates?.forEach((element) {
      debugPrint(element.name);
      debugPrint(element.points.toString());
      debugPrint(element.rank.toString());
    });
    return Container();
  }
}
