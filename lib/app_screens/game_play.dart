import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import './canvas_widget.dart';
import './candidates_list.dart';
import '../models/gamer.dart';
import './cc.dart';
import 'package:provider/provider.dart';

class GamePlay extends StatefulWidget {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  bool isAdmin;
  String Name;
  List<MapEntry<String, dynamic>> playerList;
  GamePlay({required this.room,required this.roomId,required this.pointsCollection,required this.isAdmin,required this.Name,required this.playerList});

  @override
  State<GamePlay> createState() => _GamePlayState(room: room,roomId: roomId,pointsCollection: pointsCollection,isAdmin: isAdmin,Name: Name,playerList: playerList);
// State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  bool isAdmin;
  String Name;
  List<MapEntry<String, dynamic>> playerList;
  _GamePlayState({required this.room,required this.roomId,required this.pointsCollection,required this.isAdmin,required this.Name,required this.playerList});
  Timer? countdownTimer;
  int rounds=0,duration=80,word_count=0,hints=0;
  String word_choose='';
  String guess='';
  bool isDrawing=false;
  Duration myDuration = Duration(seconds:0);
  var userId = FirebaseAuth.instance.currentUser!.uid;
  String user='';
  int count=0;
  bool guessed=false;
  double data=0.0;

  @override
  void initState() {
    super.initState();
    getParameters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(playerList.toString());
      if(playerList[0].key==Name){
        isDrawing=true;
        SelectWord();
      }
      else{
        // debugPrint(pointsList.toString());
        choosingWord();
      }
    });
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
        word_choose='';
        countdownTimer!.cancel();
        showResults();
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
    DocumentSnapshot snapshot =await room.doc('Parameters').get();
    rounds = snapshot.get('rounds');
    duration = snapshot.get('duration');
    word_count = snapshot.get('word_count');
    hints = snapshot.get('Hints');
  }
  Future choosingWord(){
    wordChange();
    return showDialog(
      context: context,
      builder: (BuildContext content){
        myDuration = Duration(seconds:10);
        startTimer();
        return AlertDialog(
          backgroundColor: Colors.white12,
          content: SizedBox(
            height: 260,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text('${playerList[count].key} is Choosing a word!'),
            ),
          ),
          insetPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 470),
        );
      },
    );
  }
  void wordChange(){
    int k=1;
    room.snapshots().listen((event) {
      var doc = event.docs.firstWhere((element) => element.id=='Parameters');
      word_choose = doc.get('word_choosen');
      debugPrint(word_choose);
      if(word_choose!='') {
        if (k==1) {
          stopTimer();
          myDuration = Duration(seconds: duration);
          startTimer();
          debugPrint('fff');
          k++;
          Navigator.pop(context);
        }
      }
    });
  }

  Future showResults() async {
    Future.delayed(Duration(seconds: 5)).then((value) {
      count++;
      guessed=false;
      data=0;
      room.doc('Parameters').update({'word_choosen':''});
      if(count==playerList.length){
        debugPrint('ggg');
        count=0;
        rounds--;
        if(rounds==0){
          //Final results
        }
      }
      debugPrint(playerList[count].key);
      if(Name==playerList[count].key){
        isDrawing=true;
      }
      else{
        isDrawing=false;
      }
      if(isDrawing==true){
        Navigator.pop(context);
        SelectWord();
      }
      else{
        Navigator.pop(context);
        choosingWord();
      }
    });
    if(isDrawing) {
      pointsCollection.remove()
          .then((value) => print('All data deleted from the collection'))
          .catchError((error) => print('Failed to delete data: $error'));
    }

    //set the total points to the user
    var got= await room.doc(userId).get();
    int tt = (got.get('points')+data).toInt();
    await room.doc(userId).update({'points':tt});

    //update individual points to the pointsList
    var gotit= await room.doc('Parameters').get();
    var list = gotit.get('pointsList');
    list[Name]=[tt,data.toInt()];
    await room.doc('Parameters').update({'pointsList': list});

    //retrieve the entire pointsList to display as results
    var check = await room.doc('Parameters').get();
    var playersRes = check.get('pointsList');
    debugPrint(playersRes.toString());
    List<MapEntry<String, dynamic>> play = playersRes.entries.toList();
      // ..sort((a, b) => b.value[1].compareTo(a.value[1]));

    // debugPrint(playersRes.entries.toList().toString());
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white12,
            content: SizedBox(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ListView(
                  children: play.map((item) {
                    return ListTile(
                      title: Text('${item.key} +${item.value[1]}.0'),
                    );
                  }).toList(),
                ),
              ),
            ),
            insetPadding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 470),
          );
        }
    );
  }

  Future SelectWord(){
    Future.delayed(Duration(seconds: 10)).then((value) {
      if(word_choose=='') {
        if (Navigator.canPop(context)) {
          word_choose = 'CAR';
          room.doc('Parameters').update({'word_choosen':'CAR'});
          stopTimer();
          myDuration = Duration(seconds: duration);
          startTimer();
          Navigator.pop(context);
        }
      }
    });
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        word_choose='';
        myDuration = Duration(seconds:10);
        startTimer();
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
                      word_choose = 'CAR';
                      room.doc('Parameters').update({'word_choosen':'CAR'});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text('CAR'),
                  ),
                  TextButton(
                    onPressed: () {
                      word_choose = 'BODY';
                      room.doc('Parameters').update({'word_choosen':'BODY'});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text('BODY'),
                  ),
                  TextButton(
                    onPressed: () {
                      word_choose = 'BLOOD';
                      room.doc('Parameters').update({'word_choosen':'BLOOD'});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
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
    debugPrint('check');
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
                  child: Draw(roomId: roomId),
                  // child: ElevatedButton(
                  //   onPressed: () {
                  //     SelectWord();
                  //   },
                  //   child: Text('Show Dialog Box'),
                  // ),
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
                        if(guess==word_choose.toLowerCase() && guessed==false){
                          debugPrint("Guessed");
                          data=double.parse(((1250/(duration-(int.parse(seconds))))).toStringAsFixed(2));
                          guessed=true;
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

