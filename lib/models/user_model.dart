import 'package:cloud_firestore/cloud_firestore.dart';

class User_model {
  final String UserName;
  final String emailAddress;
  User_model({
    required this.UserName,
    required this.emailAddress,
  });

  factory User_model.fromDocument(DocumentSnapshot doc) {
    return User_model(
      UserName: doc['Name'],
      emailAddress: doc['email'],
    );
  }
}
