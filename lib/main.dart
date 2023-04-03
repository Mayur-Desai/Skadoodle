import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:wid_learn/services/auth.dart';
import './app_screens/list_view.dart';
import './app_screens/home.dart';
import './app_screens/long_list_view.dart';
// import './app_screens/canvas_widget.dart';
import './app_screens/cc.dart';
import './app_screens/hdd.dart';
import './app_screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './models/User.dart';
import './app_screens/game_play.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "UI Widgets",
        // home: GamePlay(),
        home: wrapper(),
        // home: Draw(roomId: '224564',),
        // home: states()
        // home: Scaffold(
        //   appBar: AppBar(title: Text("List View"),),
        //   body: list_Views(),
        //   floatingActionButton: FloatingActionButton(
        //     onPressed: (){
        //       debugPrint("U clicked it!");
        //     },
        //     child: Icon(Icons.add),
        //     tooltip: "Add one more item",
        //   ),
        // ),
      ),
    )
  );
}
