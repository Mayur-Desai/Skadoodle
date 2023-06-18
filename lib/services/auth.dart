import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import 'package:flutter/material.dart';
import './database.dart';
class AuthService{
  // this instance is going to allow us to communicate with firebase auth on the backend
  // private variable
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // sign in Anonymous
  UserModel? _userFromFirebaseUser(User? user){
    return user!=null ? UserModel(uid: user.uid) : null;
  }
// auth change user stream
  Stream<UserModel?> get user {
    return FirebaseAuth.instance.authStateChanges().map(_userFromFirebaseUser);
  }
  Future signInAnon() async{
    try{
      // it returns an object amd on that we have access to a user object
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password
  Future signinwithEmailandPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerwithEmailandPassword(String email,String password,String username) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(username, email);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async{
    try{
      return await _auth.signOut();
    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }

}