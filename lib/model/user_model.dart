import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String UserName;
  final String emailAddress;
  final String password;
  final String userUid;
  UserModel({
    required this.UserName,
    required this.emailAddress,
    required this.password,
    required this.userUid,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      UserName: doc['UserName'],
      emailAddress: doc['emailAdress'],
      password: doc['password'],
      userUid: doc['userUid'],
    );
  }
}