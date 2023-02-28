import 'package:flutter/material.dart';
import '../models/gamer.dart';

class playerTile extends StatelessWidget {
  final Gamer gamer;
  playerTile({required this.gamer});
  @override
  Widget build(BuildContext context) {
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
            trailing: Icon(Icons.add_box_outlined),
          ),
        ),
    );
  }
}
