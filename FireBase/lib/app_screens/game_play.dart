import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './canvas_widget.dart';
import './candidates_list.dart';
import '../models/gamer.dart';
import 'package:provider/provider.dart';

class GamePlay extends StatefulWidget {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  GamePlay({required this.room,required this.roomId,required this.pointsCollection});

  @override
  State<GamePlay> createState() => _GamePlayState(room: room,roomId: roomId,pointsCollection: pointsCollection);
  // State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  _GamePlayState({required this.room,required this.roomId,required this.pointsCollection});
  Timer? countdownTimer;
  int rounds=0,duration=80,word_count=0,hints=0;
  String word_choose='';
  String guess='';
  Duration myDuration = Duration(seconds:0);
  final _formkey = GlobalKey<FormState>();
  // FirebaseAuth auth = FirebaseAuth.instance;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  String user='';
  Map<String, int> pointsList={};

  @override
  void initState() {
    super.initState();
    room.doc('Parameters').get().then((snapshot) {
      setState(() {
        rounds = snapshot.get('rounds');
        duration = snapshot.get('duration');
        word_count = snapshot.get('word_count');
        hints = snapshot.get('Hints');
        pointsList = snapshot.get('pointsList');
      });
    });
    room.doc(userId).get().then((value){
      setState(() {
        user=value.get('Name');
      });
    });
    myDuration = Duration(seconds:duration);
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        SelectWord();
        resetTimer();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(seconds: duration));
  }

  String setValue(){
    if(word_choose==''){
      return 'WAITING';
    }
    else{
      return word_choose;
    }
  }

  Future<void> getParameters() async {
    debugPrint("Till here");
    DocumentSnapshot snapshot =await room.doc('Parameters').get();
    rounds = snapshot.get('rounds');
    duration = snapshot.get('duration');
    word_count = snapshot.get('word_count');
    hints = snapshot.get('Hints');
    pointsList = snapshot.get('pointsList');
  }
  // Future round_result(){
  //   return showDialog(
  //       context: context,
  //       builder: builder
  //   )
  // }
  Future SelectWord(){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
            backgroundColor: Colors.white12,
            content: SizedBox(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      debugPrint("Got it");
                      word_choose = 'CAR';
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text('CAR'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint("Got it");
                      word_choose = 'BODY';
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text('BODY'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint("Got it");
                      word_choose = 'BLOOD';
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text('BLOOD'),
                  ),
                ],
              ),
            ),
            title: Text('Choose A Word!'),
            // content: Text('This is the content of my dialog box.'),
            insetPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 470),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(myDuration.inSeconds.remainder(duration));
    debugPrint(pointsList.toString());
    return StreamProvider<List<Gamer>?>.value(
      value: Players,
      initialData: null,
      child: Scaffold(
        body: Column(
          children: [
            //guess word and time
            PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.black,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(width: 5,),
                    Text(
                      '$seconds',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),
                    ),
                    Text(
                        rounds.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                        setValue(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(width: 20,),
                    TextButton.icon(
                      icon: Icon(Icons.settings),
                        onPressed: (){},
                        label: Text(''),
                    )
                  ],
                ),
                // width: 100,
              ),
            ),
            //Drawing area
            SizedBox(
              height: 350,
              child: Container(
                // child: Draw(roomParticipants: room,roomId: roomId,points: points,),
                child: ElevatedButton(
                  onPressed: () {
                    SelectWord();
                  },
                  child: Text('Show Dialog Box'),
                ),
              ),
            ),
            Expanded(
            child:Row(
              children: [
                Expanded(
                  // contestants list
                  child: Container(
                    color: Colors.deepPurple,
                    child: candidateList(iswaiting:false,isAdmin:true,roomParticipants:room),
                    // width: 100,
                  ),
                ),
                // guessed words
                Expanded(
                  child: Container(
                    color: Colors.green,
                    // width: 100,
                  ),
                ),
              ],
              )
            ),
            PreferredSize(
                child: Container(
                  height: 30,
                  child: TextField(
                    onSubmitted: (val) async {
                      setState(()  {
                        guess=val;
                        val='';
                      });
                      if(guess==word_choose.toLowerCase()){
                        debugPrint("Guessed");
                        await room.doc(userId).update({
                          'points':300
                        });
                      }
                    },
                  ),
                ),
                preferredSize: Size.fromHeight(kBottomNavigationBarHeight)
            )
          ],
        )
      ),
    );
  }
  List<Gamer> _GamerlistfromSnapshot(QuerySnapshot? snapshot){
    return snapshot!.docs.where((doc) => doc.id.length>20).map((doc) {
      return Gamer(
          name: doc.get('Name') ?? '',
          points: doc.get('points')??0,
          rank: doc.get('rank')??0
      );
    }).toList();
  }
  Stream<List<Gamer>> get Players{

    return room.snapshots().map(_GamerlistfromSnapshot);
  }
}
