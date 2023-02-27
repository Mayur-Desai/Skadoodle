import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth.dart';
class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});
  // collection reference
  // if it does not exit it'll create a new one
  final CollectionReference playerCollection = FirebaseFirestore.instance.collection('Players');

  Future updateUserData(String name,String email) async {
    // if it does not exit it'll create a new one
    return await playerCollection.doc(uid).set({
      'Name' : name,
      'email' : email,
      'points' : 0,
      'rank' : 0
    });
  }

  // Future enterRoom()

  //get  players stream
  Stream<QuerySnapshot> get player {
    return playerCollection.snapshots();
  }



}