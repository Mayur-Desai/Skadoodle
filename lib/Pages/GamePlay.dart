import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import './canvas_widget.dart';
import './selectWord.dart';
import 'package:wid_learn/Pages/components/CandidateList.dart';
import 'package:wid_learn/model/Gamer.dart';
import 'package:wid_learn/Pages/components/Canvas.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class GamePlay extends StatefulWidget {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  bool isAdmin;
  String Name;
  int r;
  List<MapEntry<String, dynamic>> playerList;
  GamePlay({required this.room,required this.roomId,required this.pointsCollection,required this.isAdmin,required this.Name,required this.playerList,required this.r});

  @override
  State<GamePlay> createState() => _GamePlayState(room: room,roomId: roomId,pointsCollection: pointsCollection,isAdmin: isAdmin,Name: Name,playerList: playerList,r:r);
// State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  final CollectionReference room;
  final pointsCollection;
  String roomId;
  bool isAdmin;
  String Name;
  int r;
  List<MapEntry<String, dynamic>> playerList;
  _GamePlayState({required this.room,required this.roomId,required this.pointsCollection,required this.isAdmin,required this.Name,required this.playerList,required this.r});
  Timer? countdownTimer;
  int rounds=0,duration=80,word_count=1,hints=0;
  String word_choose='';
  String guess='';
  bool isDrawing=false;
  Duration myDuration = Duration(seconds:0);
  var userId = FirebaseAuth.instance.currentUser!.uid;
  String user='';
  int count=0;
  bool guessed=false;
  double data=0.0;
  List<MapEntry<String, dynamic>> play=[];
  int tt=0;
  int dur=0;
  String c='';
  int randindex=0;
  String woo='';
  int hint=0;
  bool firstguess=false;
  List<String> words = ['Stapler', 'Desk', 'Pay cheque', 'Work computer', 'Fax machine', 'Phone', 'Paper', 'Light', 'Chair', 'Desk lamp', 'Notepad', 'Paper clips', 'Binder','Calculator ', 'Calendar ', 'Sticky Notes ', 'Pens', 'Pencils', 'Notebook', 'Book', 'Chairs ', 'Coffee cup', 'Chairs', 'Coffee mug', 'Thermos ', 'Hot cup', 'Glue', 'Clipboard', 'Paperclips', 'Chocolate ', 'Secretary ', 'Work', 'Paperwork', 'Workload ', 'Employee', 'Boredom', 'Coffee', 'Golf ', 'Laptop', 'Sandcastle', 'Monday', 'Vanilla', 'Bamboo', 'Sneeze', 'Scratch ', 'Celery ', 'Hammer', 'Frog ', 'Tennis', 'Hot dog', 'Pants', 'Bridge', 'Bubblegum', 'Candy bar', 'Bucket ', 'Skiing ', 'Sledding', 'Snowboarding ', 'Snowman ', 'Polar bear', 'Cream', 'Waffle', 'Pancakes', 'Ice cream', 'Sundae ', 'beach', 'Sunglasses', 'Surfboard', 'Watermelon', 'Baseball', 'Bat', 'Ball', 'T-shirt', 'Kiss', 'Jellyfish', 'Jelly', 'Butterfly', 'Spider', 'Broom', 'Spiderweb', 'Mummy', 'Candy', 'Bays', 'Squirrels', 'Basketball', 'Water Bottle', 'Unicorn', 'Dog leash', 'Newspaper', 'Hammock', 'Video camera', 'Money', 'Smiley face', 'Umbrella', 'Picnic basket', 'Teddy bear ', 'Ambulance', 'Ancient Pyramids', 'Bacteria', 'Goosebumps', 'Pizza', 'Platypus', 'Clam Chowder', 'Goldfish bowl', 'Skull', 'Spiderweb', 'Smoke', 'Tree', 'Ice', 'Blanket', 'Seaweed', 'Flame', 'Bubble', 'Hair ', 'Tooth', 'Leaf', 'Worm', 'Sky', 'Apple', 'Plane', 'Cow', 'House', 'Dog', 'Car', 'Bed', 'Furniture', 'Train', 'Rainbow', 'Paintings', 'Drawing', 'Cup', 'Plate', 'Bowl', 'Cushion', 'Sofa', 'Sheet', 'Kitchen', 'Table', 'Candle', 'Shirt', 'Clothes', 'Dress', 'Pillow', 'Home', 'Toothpaste', 'Guitar', 'Schoolbag', 'Pencil Case', 'Glasses', 'Towel', 'Watch', 'Piano', 'Pen', 'Hat', 'Shoes', 'Socks ', 'Jeans', 'Hair Gel', 'Keyboard', 'Bra', 'Jacket', 'Tie', 'Bandage ', 'Scarf', 'Hair Brush','Cell Phone', 'Printer', 'Cork Board', 'Office Supplies ', 'Cork Board', 'Paperweight', 'Letter Opener ', 'Post-It notes', 'Pen holder', 'File cabinet', 'Boss', 'Water-cooler', 'Commute ', 'Lunch break', 'Employer', 'Late', 'Passion', 'Ambition', 'Pay', 'Pride ', 'Unemployment', 'Job', 'Hire', 'Lazy', 'Worried', 'Tired', 'Poverty', 'Olympics ', 'Recycle', 'Black hole', 'Applause ', 'Blizzard', 'Sunburn', 'Time Machine', 'Lace', 'Atlantis ', 'Swamp', 'Sunscreen', 'Dictionary', 'Century ', 'Sculpture', 'Sneaker', 'Admiral', 'Water polo', 'Ninja', 'Snorkeling', 'Surfing', 'Volleyball', 'Pitcher', 'Catcher', 'Batter', 'Home Plate ', 'Swing', 'Cheerleader', 'Pumpkin', 'Halloween', 'Ghost', 'Jack-oâ€™-lantern', 'Spooky', 'Skeleton', 'Vampire', 'Scary', 'Witch', 'Noodles', 'Hula hoop', 'Unicycle', 'Whiteboard', 'Knitting', 'Thunderstorm', 'Bubble wrap', 'Thermometer ', 'Skipping Rope', 'Canned Food', 'Waffles ', 'Chalkboard', 'Home run', 'Milkshake', 'Snowball fight', 'Bug zapper ', 'Pot of gold', 'Loudspeaker', 'Wind chimes', 'Musical instrument', 'Bird feeder', 'Bookworm', 'Wig', 'Monster Truck', 'Houseplant', 'Pie chart', 'Water gun', 'Shopping cart', 'Knife and fork', 'Blue whale', 'CanaryIslands', 'Christmas tree', 'Daytime', 'Earthquake', 'Frog legs', 'Junkyard ', 'Vomiting ', 'Aardvark', 'Dolphin ', ' Rainforest', 'Spiders Web', 'Great Wall of China', 'Bat', 'Worms', 'X-Ray', 'Yawning', 'Daytime TV', 'Fireman', 'Frogs Legs', 'Hard hat', 'Hospital gown', 'Invisible Man', 'Underwear', 'Quicksand', 'Stomach ache', 'Vacuum cleaner', 'Swiss cheese ', 'Cream cheese', 'Pizza crust', 'Bruise', 'Fog', 'Crust', 'Battery', 'Cereal', 'Blood', 'Moss', 'Thorn', 'Algae', 'Slug', 'Antenna', 'Butterfly Wing', 'Parasite ', 'Pollen', 'Asteroid', 'Family', 'Painting', 'Sketch', 'Wallpaper', 'Chandelier', 'Ketchup ', 'Plane ticket', 'Fruit juice', 'Slippers', 'Sneakers ', 'Salary', 'Punctuality', 'Slacking', 'Stress', 'Overtime', 'Redundant ', 'Unemployed', 'Disconnect', 'Freelance', 'Part-time', 'Workaholic', 'Stressful', 'Exhausted ', 'Worries', 'Career', 'Overqualified', 'Unhappy', 'Panama Canal', 'Cheer', 'Vacation', 'Trick-or-treat ', 'Egghead', 'Hypnosis', 'Fidget spinner', 'Artificial Intelligence', 'Scientific research', 'Dreamcatcher', 'Screaming child', 'Jello shots', 'Surprise party', 'Chilli cheese dog', 'Mugshot', 'Moonwalk', 'Couch potato', 'Aurora Borealis', 'Leaning Tower ofPisa', 'Fairy', 'Steamed Hams ', 'Hornets Nest', 'Immune System', 'Mushroom', 'The Sun', 'Zebra', 'Computer ', 'Lawnmower', 'Moonwalking', 'Oyster crackers', 'Striped pajamas', 'Shaving cream', 'Hiccups', 'Breath Mints', 'Body odor', 'Chicken pox', 'Actor', 'Gold', 'Painting', 'Advertisement', 'Grass', 'Parrot', 'Afternoon', 'Greece', 'Pencil', 'Airport', 'Guitar', 'Piano', 'Ambulance', 'Hair', 'Pillow', 'Animal', 'Hamburger', 'Pizza', 'Answer', 'Helicopter', 'Planet', 'Apple', 'Helmet', 'Plastic', 'Army', 'Holiday', 'Portugal', 'Australia', 'Honey', 'Potato', 'Balloon', 'Horse', 'Queen', 'Banana', 'Hospital', 'Quill', 'Battery', 'House', 'Rain', 'Beach', 'Hydrogen', 'Rainbow', 'Beard', 'Ice', 'Raincoat', 'Bed', 'Insect'];
  Random random = new Random();
  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final chats;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chats = database.child('chats$roomId');
    room.doc(FirebaseAuth.instance.currentUser!.uid).update({'guessed':false});
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    if(isAdmin){
      chats.push().set({
        Name:'',
        'timestamp': ServerValue.timestamp
      }).asStream;
    }
    getParameters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(playerList.toString());
      if(playerList[0].key==Name){
        isDrawing=true;
        room.doc(userId).update({'isDrawing':true});
        SelectWord();
        // Navigator.push(
          // context,
          // MaterialPageRoute(builder: (context) => select()),
        // );
        // select();
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
    setState((){
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        word_choose='';
        countdownTimer!.cancel();
        debugPrint("settimer fun");
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
  String replaceCharAt(String oldString, int index, String newChar) {
    if(index!=0){
      index+=index;
    }
    return oldString.substring(0, index) + newChar + oldString.substring(index+1);
  }
  String setValue(final seconds){
    if(word_choose==''){
      return 'WAITING';
    }
    else{
      if(!isDrawing){
        String spaces(n) => new List.filled(n + 1, '_ ').join();
        debugPrint(dur.toString());
        debugPrint(seconds.toString());
        int y = int.parse(seconds);
        if(y.toString()==dur.toString() && hint>0){
          dur = (dur/2).toInt();
          hint--;
          randindex = random.nextInt(word_choose.length);
          debugPrint("index: $randindex");
          c = word_choose[randindex];
          woo =replaceCharAt(woo, randindex, c);
          debugPrint(woo);
          return woo;
        }
        else if(c==''){
          woo = spaces(word_choose.length-1);
          return woo;
        }
        else{
          return woo;
        }
      }
      else{
        return word_choose;
      }
    }
  }

  Future<void> getParameters() async {
    DocumentSnapshot snapshot =await room.doc('Parameters').get();
    rounds = snapshot.get('rounds');
    duration = snapshot.get('duration');
    word_count = snapshot.get('word_count');
    hints = snapshot.get('Hints');
    dur=(duration/2).toInt();
    hint=hints;
  }
  Future choosingWord(){
    return showDialog(
      barrierDismissible:false,
        context: context,
        builder: (BuildContext context){
        myDuration = Duration(seconds:10);
        startTimer();
        wordChange(context);
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
  void wordChange(BuildContext context){
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
  void ddee(BuildContext context){
  Future.delayed(Duration(seconds: 5)).then((value) {
  count++;
  guessed=false;
  firstguess=false;
  data=0.0;
  room.doc('Parameters').update({'word_choosen':''});
  room.doc(userId).update({'guessed':false});
  if(count==playerList.length){
  debugPrint('ggg');
  count=0;
  rounds--;
  }
  if(rounds==0){
  //Final results
  debugPrint("lly");
  Navigator.pop(context);
  FinalResult(play);
  }
  else
  {
  // debugPrint(playerList[count].key);
  if (Name == playerList[count].key) {
  isDrawing = true;
  room.doc(userId).update({'isDrawing':true});
  } else {
  isDrawing = false;
  room.doc(userId).update({'isDrawing':false});
  }
  if (isDrawing == true) {
  // debugPrint("opppp");
  Navigator.of(context).pop();
  SelectWord();
  } else {
  Navigator.pop(context);
  choosingWord();
  }
  }
  });
}
  Future showResults() async {
    // Future.delayed(Duration(seconds: 5)).then((value) {
    //   count++;
    //   guessed=false;
    //   firstguess=false;
    //   data=0.0;
    //   room.doc('Parameters').update({'word_choosen':''});
    //   room.doc(userId).update({'guessed':false});
    //   if(count==playerList.length){
    //     debugPrint('ggg');
    //     count=0;
    //     rounds--;
    //   }
    //   if(rounds==0){
    //     //Final results
    //     debugPrint("lly");
    //     Navigator.pop(context);
    //     FinalResult(play);
    //   }
    //   else
    //   {
    //     // debugPrint(playerList[count].key);
    //     if (Name == playerList[count].key) {
    //       isDrawing = true;
    //       room.doc(userId).update({'isDrawing':true});
    //     } else {
    //       isDrawing = false;
    //       room.doc(userId).update({'isDrawing':false});
    //     }
    //     if (isDrawing == true) {
    //       // debugPrint("opppp");
    //       Navigator.of(context).pop();
    //       SelectWord();
    //     } else {
    //       Navigator.pop(context);
    //       choosingWord();
    //     }
    //   }
    // });
    if(isDrawing) {
      pointsCollection.remove()
          .then((value) => print('All data deleted from the collection'))
          .catchError((error) => print('Failed to delete data: $error'));
    }
    woo='';
    c='';
    hint=hints;
    dur=(duration/2).toInt();
    var check = await room.doc('Parameters').get();
    var playersRes = check.get('pointsList');
    debugPrint(playersRes.toString());
    play = playersRes.entries.toList();
    play.sort((a, b) => b.value[1].compareTo(a.value[1]));
    int i=play.indexWhere((entry) => entry.key == Name);
    room.doc(userId).update({'rank':i+1});
    room.doc(userId).update({'points':tt});
    data=0.0;
    // debugPrint(playersRes.entries.toList().toString());
    return showDialog(
        barrierDismissible:false,
        context: context,
        builder: (BuildContext context){
          ddee(context);
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

  Future FinalResult(List<MapEntry<String, dynamic>> play){
    play.sort((a, b) => b.value[0].compareTo(a.value[0]));
    int k=1;
    debugPrint("ewe");
    return showDialog(
        barrierDismissible:false,
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
                      title: Text('${k++} - ${item.key}'),
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
  void sseee(BuildContext context,String a){
    Future.delayed(Duration(seconds: 10)).then((value) {
      if(word_choose=='') {
        if (Navigator.canPop(context)) {
          word_choose = a;
          room.doc('Parameters').update({'word_choosen':a});
          stopTimer();
          myDuration = Duration(seconds: duration);
          startTimer();
          Navigator.of(context).pop();
        }
      }
    });
  }
  Future SelectWord(){
    debugPrint("select word!");
    String a,b,c;
    int randomNumber = random.nextInt(words.length);
    a=words[randomNumber];
    randomNumber = random.nextInt(words.length);
    b=words[randomNumber];
    randomNumber = random.nextInt(words.length);
    c=words[randomNumber];

    // Future.delayed(Duration(seconds: 10)).then((value) {
    //   if(word_choose=='') {
    //     if (Navigator.canPop(context)) {
    //       word_choose = a;
    //       room.doc('Parameters').update({'word_choosen':a});
    //       stopTimer();
    //       myDuration = Duration(seconds: duration);
    //       startTimer();
    //       Navigator.of(context).pop();
    //     }
    //   }
    // });
    return showDialog(
      barrierDismissible:false,
      context: context,
      builder: (BuildContext context) {
        word_choose='';
        myDuration = Duration(seconds:10);
        startTimer();
        sseee(context, a);
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
                      word_choose = a;
                      room.doc('Parameters').update({'word_choosen':a});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text(a),
                  ),
                  TextButton(
                    onPressed: () {
                      word_choose = b;
                      room.doc('Parameters').update({'word_choosen':b});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text(b),
                  ),
                  TextButton(
                    onPressed: () {
                      word_choose = c;
                      room.doc('Parameters').update({'word_choosen':c});
                      stopTimer();
                      myDuration = Duration(seconds:duration);
                      startTimer();
                      Navigator.of(context).pop();
                    },
                    child: Text(c),
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
  void update(final seconds) async {
    debugPrint(firstguess.toString());
    if(firstguess==true && isDrawing==true && data==0.0){
      debugPrint("first guess");
      double dd=1250/(duration-(int.parse(seconds)));
      data=double.parse(((dd)).toStringAsFixed(2));
      debugPrint(data.toString());
      var got= await room.doc(userId).get();
      tt = (got.get('points')+data.toInt()).toInt();
      debugPrint("total:$tt");
      var gotit= await room.doc('Parameters').get();
      var list = gotit.get('pointsList');
      list[Name]=[tt,data.toInt()];
      await room.doc('Parameters').update({'pointsList': list});
      guessed = true;
      firstguess=false;
    }
    if(seconds.toString()=='01' && guessed==false){
      var gotit= await room.doc('Parameters').get();
      var list = gotit.get('pointsList');
      list[Name]=[tt,data.toInt()];
      await room.doc('Parameters').update({'pointsList': list});
    }
  }
  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(myDuration.inSeconds.remainder(duration));
    debugPrint('check');
    update(seconds);
    return StreamProvider<List<Gamer>?>.value(
      value: Players,
      initialData: null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              //guess word and time
              PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          width: 1,
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17),bottomRight: Radius.circular(17))
                    ),
                    height: 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        // SizedBox(width: 5,),
                        Image.asset('images/timer.gif',height: 45.0, width: 45.0,),
                        Text(
                          ':$seconds',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 35,),
                        Image.asset('images/rounds.gif',height: 35.0, width: 35.0,),
                        Text(
                          ':'+rounds.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 45,),
                        Text(
                          setValue(seconds),
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontFamily: 'JoseFins'
                          ),
                        ),
                        SizedBox(width: 45,),
                        TextButton.icon(
                          icon: Icon(Icons.arrow_circle_right,color: Colors.white38,),
                          onPressed: (){
                            room.doc(userId).delete();
                            if(isAdmin==true){
                              Navigator.pop(context);
                            }
                            Navigator.pop(context);
                          },
                          label: Text(''),
                        )
                      ],
                    ),
                    // width: 100,
                  ),
                ),
              ),
              //Drawing area
              SizedBox(
                height: 350,
                child: Container(
                  child: Draw(roomId: roomId),
                ),
              ),
              Expanded(
                  child:Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          width: 1,
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17),bottomRight: Radius.circular(17))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          // contestants list
                          // flex:2,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.brown[400],
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black26,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: candidateList(iswaiting:false,isAdmin:true,roomParticipants:room),
                            // width: 100,
                          ),
                        ),
                        Flexible(
                          // flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.brown[400],
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black26,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: FirebaseAnimatedList(
                                  controller: _scrollController,
                                  // shrinkWrap: true,
                                  query: chats.orderByChild('timestamp'),
                                  itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double> nimation,int index){
                                    var data = jsonDecode(jsonEncode(snapshot.value));
                                    // debugPrint(data.toString());
                                    String n = data.keys.first;
                                    // if(n!=null){//how to get the condition where there is a card?
                                    //   _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(microseconds: 500), curve: Curves.easeOut);
                                    // }
                                    if (index == 0) {
                                      // return the header
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:  [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text("Chats",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.lightGreenAccent,
                                                    fontSize: 18
                                                ),
                                              ),
                                              SizedBox(width: 10,),

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(18.0),
                                                child: Image.asset('images/chat.jpg',height: 25.0, width: 25.0,),
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    index -= 1;
                                    return Card(
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.all(5) ,
                                      child: ListTile(
                                        shape: BeveledRectangleBorder( //<-- SEE HERE
                                          //side: BorderSide(width: 1),
                                          side: BorderSide(
                                            width: 1,
                                            color: Colors.black54,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          "  "+n,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),

                                        dense: true,
                                        visualDensity: VisualDensity(vertical: -4),
                                        tileColor: data[n]=='has guessed the word!'?Colors.green:Colors.yellow,
                                        subtitle: Text(
                                          "        "+ data[n],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),

                        )
                      ],
                    ),
                  )
              ),
              SizedBox(height: 7,),
              PreferredSize(
                  preferredSize: Size.fromHeight(kBottomNavigationBarHeight),
                  child: Container(
                    height: 30,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Guess Here!',
                      ),
                      onSubmitted: (val) async {
                        setState(()  {
                          guess=val;
                          if(guess.similarityTo(word_choose.toLowerCase())>=0.6 && guess!=word_choose.toLowerCase()){
                            showToast();
                          }
                          chats.push().set({
                            Name:guess==word_choose.toLowerCase()?isDrawing==false?'has guessed the word!':guess:guess,
                            'timestamp': ServerValue.timestamp
                          }).asStream;
                          _textController.clear();
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        });
                        if(guess==word_choose.toLowerCase() && guessed==false && isDrawing==false){
                          debugPrint("Guessed");
                          debugPrint(seconds);
                          double dd=1250/(duration-(int.parse(seconds)));
                          data=double.parse(((dd)+20).toStringAsFixed(2));
                          debugPrint("guessed point: "+data.toString());
                          var got= await room.doc(userId).get();
                          tt = (got.get('points')+data).toInt();
                          debugPrint("total:$tt");
                          var gotit= await room.doc('Parameters').get();
                          var list = gotit.get('pointsList');
                          list[Name]=[tt,data.toInt()];
                          await room.doc('Parameters').update({'pointsList': list});
                          await room.doc(userId).update({'guessed':true});
                          guessed=true;
                        }
                      },
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
  void showToast() {
    Fluttertoast.showToast(
        msg: 'That was Close!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.yellow
    );
  }
  List<Gamer> _GamerlistfromSnapshot(QuerySnapshot? snapshot){
    return snapshot!.docs.where((doc) => doc.id.length>20).map((doc) {
      return Gamer(
          name: doc.get('Name') ?? '',
          points: doc.get('points')??0,
          rank: doc.get('rank')??0,
          index: doc.get('img')??0,
          guessed: doc.get('guessed')?firstguess=true:false
      );
    }).toList();
  }
  Stream<List<Gamer>> get Players{
    return room.snapshots().map(_GamerlistfromSnapshot);
  }
}
