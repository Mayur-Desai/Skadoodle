import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GG extends StatefulWidget {
  const GG({Key? key}) : super(key: key);

  @override
  State<GG> createState() => _GGState();
}

class _GGState extends State<GG> {
  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final pointsCollection;
  @override
  void initState()  {
    pointsCollection = database;
  }
  Future<void> add()async{
    try{
      await pointsCollection.child('points').set({
        "name": "John",
        "age": 18,
        "address": {
          "line1": "100 Mountain View"
        }
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: (){
          add();
        }, child: Text("GG"),
      ),
    );
  }
}
