import "package:flutter/material.dart";

class list_Views extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return getListView();
    throw UnimplementedError();
  }
  Widget getListView(){
    var listview= ListView(
      children: [
        ListTile(
          leading: Icon(Icons.landscape_outlined),
          title: Text("Landscape"),
          subtitle: Text("Nature!"),
          trailing: Icon(Icons.wb_cloudy),
          onTap: (){
            debugPrint("Landscape tapped");
          },
        ),
        ListTile(
          leading: Icon(Icons.laptop),
          title: Text("Laptop"),
          subtitle: Text("Electronic"),
        ),
        ListTile(
          leading: Icon(Icons.face),
          title: Text("Person"),
          subtitle: Text("call"),
          trailing: Icon(Icons.phone),
        ),
        Text("Trying out new Things!"),
        Container(
          color:Colors.deepPurple,
          height: 20.0,
        )
      ],
    );
    return listview;
  }
}