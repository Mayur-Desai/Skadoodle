import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import './game_settings.dart';
import './waiting_room.dart';

class room extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => roomLogin();
}
class roomLogin extends State<room>{

  // used for signout function in the auth file
  final AuthService _auth = AuthService();

  // used to create a private room
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // instance to create a new collection
  late CollectionReference roomParticipants;

  // used to select a unique room ID
  Set roomId ={};
  Random random = new Random();
  String? Id;
  late User_model userModel;

  // keeping track of the room admin
  bool isAdmin = false;
  Future getCurrentUserDataFunction() async {
    debugPrint("testtt");
    await FirebaseFirestore.instance
        .collection("Players")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
          (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userModel = User_model.fromDocument(documentSnapshot);
        } else {
          print("Document does not exist the database");
        }

      },
    );
    debugPrint(userModel.UserName);
  }
  @override
  void initState(){
    getCurrentUserDataFunction();
    // debugPrint(userModel.UserName);
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().player,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          actions: [
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text("Logout"),
                onPressed: () async{
                  await _auth.signout();
                },
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Text("Create a Private Room"),
                SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: () async {
                      // debugPrint("Till here");
                      int randomNumber;
                      do{
                        randomNumber = 100000 + random.nextInt(1000000 - 100000);
                      }while(roomId.contains(randomNumber));
                      roomId.add(randomNumber);
                      // debugPrint("Till here");
                      CollectionReference words = FirebaseFirestore.instance.collection('Words');
                      words.doc('Words').set({
                        'word':['Stapler', 'Desk', 'Pay cheque', 'Work computer', 'Fax machine', 'Phone', 'Paper', 'Light', 'Chair', 'Desk lamp', 'Notepad', 'Paper clips', 'Binder','Calculator ', 'Calendar ', 'Sticky Notes ', 'Pens', 'Pencils', 'Notebook', 'Book', 'Chairs ', 'Coffee cup', 'Chairs', 'Coffee mug', 'Thermos ', 'Hot cup', 'Glue', 'Clipboard', 'Paperclips', 'Chocolate ', 'Secretary ', 'Work', 'Paperwork', 'Workload ', 'Employee', 'Boredom', 'Coffee', 'Golf ', 'Laptop', 'Sandcastle', 'Monday', 'Vanilla', 'Bamboo', 'Sneeze', 'Scratch ', 'Celery ', 'Hammer', 'Frog ', 'Tennis', 'Hot dog', 'Pants', 'Bridge', 'Bubblegum', 'Candy bar', 'Bucket ', 'Skiing ', 'Sledding', 'Snowboarding ', 'Snowman ', 'Polar bear', 'Cream', 'Waffle', 'Pancakes', 'Ice cream', 'Sundae ', 'beach', 'Sunglasses', 'Surfboard', 'Watermelon', 'Baseball', 'Bat', 'Ball', 'T-shirt', 'Kiss', 'Jellyfish', 'Jelly', 'Butterfly', 'Spider', 'Broom', 'Spiderweb', 'Mummy', 'Candy', 'Bays', 'Squirrels', 'Basketball', 'Water Bottle', 'Unicorn', 'Dog leash', 'Newspaper', 'Hammock', 'Video camera', 'Money', 'Smiley face', 'Umbrella', 'Picnic basket', 'Teddy bear ', 'Ambulance', 'Ancient Pyramids', 'Bacteria', 'Goosebumps', 'Pizza', 'Platypus', 'Clam Chowder', 'Goldfish bowl', 'Skull', 'Spiderweb', 'Smoke', 'Tree', 'Ice', 'Blanket', 'Seaweed', 'Flame', 'Bubble', 'Hair ', 'Tooth', 'Leaf', 'Worm', 'Sky', 'Apple', 'Plane', 'Cow', 'House', 'Dog', 'Car', 'Bed', 'Furniture', 'Train', 'Rainbow', 'Paintings', 'Drawing', 'Cup', 'Plate', 'Bowl', 'Cushion', 'Sofa', 'Sheet', 'Kitchen', 'Table', 'Candle', 'Shirt', 'Clothes', 'Dress', 'Pillow', 'Home', 'Toothpaste', 'Guitar', 'Schoolbag', 'Pencil Case', 'Glasses', 'Towel', 'Watch', 'Piano', 'Pen', 'Hat', 'Shoes', 'Socks ', 'Jeans', 'Hair Gel', 'Keyboard', 'Bra', 'Jacket', 'Tie', 'Bandage ', 'Scarf', 'Hair Brush','Cell Phone', 'Printer', 'Cork Board', 'Office Supplies ', 'Cork Board', 'Paperweight', 'Letter Opener ', 'Post-It notes', 'Pen holder', 'File cabinet', 'Boss', 'Water-cooler', 'Commute ', 'Lunch break', 'Employer', 'Late', 'Passion', 'Ambition', 'Pay', 'Pride ', 'Unemployment', 'Job', 'Hire', 'Lazy', 'Worried', 'Tired', 'Poverty', 'Olympics ', 'Recycle', 'Black hole', 'Applause ', 'Blizzard', 'Sunburn', 'Time Machine', 'Lace', 'Atlantis ', 'Swamp', 'Sunscreen', 'Dictionary', 'Century ', 'Sculpture', 'Sneaker', 'Admiral', 'Water polo', 'Ninja', 'Snorkeling', 'Surfing', 'Volleyball', 'Pitcher', 'Catcher', 'Batter', 'Home Plate ', 'Swing', 'Cheerleader', 'Pumpkin', 'Halloween', 'Ghost', 'Jack-oâ€™-lantern', 'Spooky', 'Skeleton', 'Vampire', 'Scary', 'Witch', 'Noodles', 'Hula hoop', 'Unicycle', 'Whiteboard', 'Knitting', 'Thunderstorm', 'Bubble wrap', 'Thermometer ', 'Skipping Rope', 'Canned Food', 'Waffles ', 'Chalkboard', 'Home run', 'Milkshake', 'Snowball fight', 'Bug zapper ', 'Pot of gold', 'Loudspeaker', 'Wind chimes', 'Musical instrument', 'Bird feeder', 'Bookworm', 'Wig', 'Monster Truck', 'Houseplant', 'Pie chart', 'Water gun', 'Shopping cart', 'Knife and fork', 'Blue whale', 'CanaryIslands', 'Christmas tree', 'Daytime', 'Earthquake', 'Frog legs', 'Junkyard ', 'Vomiting ', 'Aardvark', 'Dolphin ', ' Rainforest', 'Spiders Web', 'Great Wall of China', 'Bat', 'Worms', 'X-Ray', 'Yawning', 'Daytime TV', 'Fireman', 'Frogs Legs', 'Hard hat', 'Hospital gown', 'Invisible Man', 'Underwear', 'Quicksand', 'Stomach ache', 'Vacuum cleaner', 'Swiss cheese ', 'Cream cheese', 'Pizza crust', 'Bruise', 'Fog', 'Crust', 'Battery', 'Cereal', 'Blood', 'Moss', 'Thorn', 'Algae', 'Slug', 'Antenna', 'Butterfly Wing', 'Parasite ', 'Pollen', 'Asteroid', 'Family', 'Painting', 'Sketch', 'Wallpaper', 'Chandelier', 'Ketchup ', 'Plane ticket', 'Fruit juice', 'Slippers', 'Sneakers ', 'Salary', 'Punctuality', 'Slacking', 'Stress', 'Overtime', 'Redundant ', 'Unemployed', 'Disconnect', 'Freelance', 'Part-time', 'Workaholic', 'Stressful', 'Exhausted ', 'Worries', 'Career', 'Overqualified', 'Unhappy', 'Panama Canal', 'Cheer', 'Vacation', 'Trick-or-treat ', 'Egghead', 'Hypnosis', 'Fidget spinner', 'Artificial Intelligence', 'Scientific research', 'Dreamcatcher', 'Screaming child', 'Jello shots', 'Surprise party', 'Chilli cheese dog', 'Mugshot', 'Moonwalk', 'Couch potato', 'Aurora Borealis', 'Leaning Tower ofPisa', 'Fairy', 'Steamed Hams ', 'Hornets Nest', 'Immune System', 'Mushroom', 'The Sun', 'Zebra', 'Computer ', 'Lawnmower', 'Moonwalking', 'Oyster crackers', 'Striped pajamas', 'Shaving cream', 'Hiccups', 'Breath Mints', 'Body odor', 'Chicken pox', 'Actor', 'Gold', 'Painting', 'Advertisement', 'Grass', 'Parrot', 'Afternoon', 'Greece', 'Pencil', 'Airport', 'Guitar', 'Piano', 'Ambulance', 'Hair', 'Pillow', 'Animal', 'Hamburger', 'Pizza', 'Answer', 'Helicopter', 'Planet', 'Apple', 'Helmet', 'Plastic', 'Army', 'Holiday', 'Portugal', 'Australia', 'Honey', 'Potato', 'Balloon', 'Horse', 'Queen', 'Banana', 'Hospital', 'Quill', 'Battery', 'House', 'Rain', 'Beach', 'Hydrogen', 'Rainbow', 'Beard', 'Ice', 'Raincoat', 'Bed', 'Insect']
                      });

                      roomParticipants = FirebaseFirestore.instance.collection(randomNumber.toString());
                      var userId = auth.currentUser!.uid;
                      var userData = await firestore.collection('Players').doc(userId).get();
                      await roomParticipants.doc(userId).set(userData.data());
                      String name=userData.get('Name');
                      Map<String,dynamic> data = {name:[0,0]};
                      await roomParticipants.doc("Parameters").set({
                        'isPressed':false,
                        'rounds':0,
                        'duration':0,
                        'word_count':3,
                        'Hints':2,
                        'word_choosen':'',
                        'pointsList':data
                      });
                      roomParticipants.doc(userId).update({'isDrawing':true});
                      debugPrint(randomNumber.toString());
                      isAdmin=true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameSettings(roomParticipants: roomParticipants,roomId: randomNumber.toString(),isAdmin: isAdmin,Name:name)),
                      );
                    },
                    child: Text("CREATE")
                ),
                SizedBox(height: 20.0,),
                Text("Enter a Private Room"),
                SizedBox(height: 20.0,),
                TextFormField(
                  validator: (val)=> val!.length<6 ? 'Enter a Valid Id':null,
                  onChanged: (val){
                    setState(()=> Id = val);
                    debugPrint(Id.toString());
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      debugPrint(Id);
                      roomParticipants = FirebaseFirestore.instance.collection(Id!);
                      var userId = auth.currentUser!.uid;
                      var userData = await firestore.collection('Players').doc(userId).get();
                      await roomParticipants.doc(userId).set(userData.data());
                      var sd = await roomParticipants.doc('Parameters').get();
                      Map<String,dynamic> data = sd.get('pointsList');
                      String name=userData.get('Name');
                      data[name]=[0,0];
                      await roomParticipants.doc('Parameters').update({'pointsList':data});
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: Id!,isAdmin: isAdmin,Name:name)),
                      );
                    },
                    child: Text("Enter")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}