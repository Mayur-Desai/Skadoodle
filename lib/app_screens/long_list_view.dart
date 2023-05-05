import 'package:flutter/material.dart';

class long_list extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return getLongListView();
  }
  void showSnackBar(BuildContext context,String item){
    var snackBar = SnackBar(
      content: Text("You Tapped $item"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: (){
          debugPrint("undo!");
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  List<String> getListElements(){
    var items = List<String>.generate(11, (index) => "Item $index");
    return items;
  }
  Widget getLongListView(){
    var listitems=getListElements();
    var listview=ListView.builder(
        itemCount: listitems.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(listitems[index]),
            onTap: (){
              showSnackBar(context,listitems[index]);
            },
          );
        }
    );
    return listview;
  }
}