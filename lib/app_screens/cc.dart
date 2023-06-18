import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Draw extends StatefulWidget{
  // final CollectionReference roomParticipants;
  String roomId;
  // bool isDrawing;
  // final pointsColl;
  // final CollectionReference points;
  Draw({required this.roomId});
  @override
  _DrawState createState() => _DrawState(roomId: roomId);

}
class _DrawState extends State<Draw>{
  // final CollectionReference roomParticipants;
  String roomId;
  List<DrawModel?> pointsList = [];
  bool isDrawing=false;
  // final pointsStream = BehaviorSubject<List<DrawModel?>>(); // acts as a stack
  GlobalKey key =GlobalKey();

  // DatabaseReference pointsCollection = FirebaseDatabase.instance.reference();
  int count=100000000;
  int i=0;
  List<DrawModel?> pointslist=[];
  _DrawState({required this.roomId});

  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final pointsCollection ;
  late CollectionReference room;
  Color selectedColor = Color(3707764736);
  List<Color> _colors = [Colors.red,Colors.green,Colors.blue,Colors.yellow,Colors.orange,Colors.purple,Colors.pink,Colors.teal,Colors.black];
  double strokeWidth = 7;

  void selectColor() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choose Color'),
          content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  String colorString = color.toString();
                  String valueString =
                  colorString.split('(0x')[1].split(')')[0];
                  int value = int.parse(valueString, radix: 16);
                  // print(colorString);
                  // print(valueString);
                  selectedColor = Color(value);
                  Navigator.of(context).pop();
                },
                availableColors: _colors,
              )),
        ));
  }

  @override
  void initState() {
    pointsCollection= database.child('Points/points$roomId');
    room = FirebaseFirestore.instance.collection(roomId);
    changes();
    debugPrint("cccccc");
  }
  void changes(){
    debugPrint("opbahii");
    room.snapshots().listen((snapshot) {
      var check = snapshot.docs.firstWhere((doc) => doc.id==FirebaseAuth.instance.currentUser!.uid);
      isDrawing = check.get('isDrawing');
      debugPrint('ppppppp');
    });
  }
  Future<void> _addpointslist(DrawModel? points) async {
    try{
      if(points==null){
        await pointsCollection.child((count++).toString()).set({
          'End':0,
        });
      }
      else {
        await pointsCollection.child((count++).toString()).set({
          'x': points!.offset.dx,
          'y': points!.offset.dy,
          'color': points.paint.color.value,
          'strokewidth': points.paint.strokeWidth
        }).then((_){

        });
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        body:
        Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanDown: (details) {
                  if (isDrawing) {
                    setState(() {
                      //we want to access the low-level layout and painting properties of the widget we are casting the RenderObject method's result as RenderBox
                      RenderBox renderBox = key.currentContext
                          ?.findRenderObject() as RenderBox;
                      Paint paint = Paint(); //creating a paint object
                      //assigning properties
                      paint.color = selectedColor;
                      paint.strokeWidth = strokeWidth;
                      paint.strokeCap = StrokeCap.round;
                      pointsList.add(DrawModel(
                          renderBox.globalToLocal(details.globalPosition), paint));
                      //add to database
                      _addpointslist(pointsList.last!);
                      // draw();
                    });
                  }
                },
                onPanUpdate: (details){
                  if(isDrawing){
                  RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
                  Paint paint = Paint();
                  paint.color = selectedColor;
                  paint.strokeWidth = strokeWidth;
                  paint.strokeCap = StrokeCap.round;
                  pointsList.add(DrawModel(renderBox.globalToLocal(details.globalPosition), paint));
                  _addpointslist(pointsList.last!);
                  }
                },
                onPanEnd: (details){
                  setState(() {
                    pointsList.add(null);
                    _addpointslist(pointsList.last);
                  });
                },

                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<DataSnapshot>(
                    stream: pointsCollection.onValue.map((event) => event.snapshot).cast<DataSnapshot>(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return CustomPaint(
                          painter: DrawingPainter(pointsList),
                        );
                      }
                      String jsonStr = jsonEncode(snapshot.data!.value);
                      if(jsonStr!='null'){
                        Map<String, dynamic> unsortedData = jsonDecode(jsonStr);
                        List<String> sortedKeys = unsortedData!.keys.toList()..sort();
                        Map<String, dynamic> data = Map.fromIterable(
                          sortedKeys,
                          key: (key) => key,
                          value: (key) => unsortedData[key],
                        );
                        pointslist = (data as Map<dynamic,dynamic>).entries.map((e) {
                          // debugPrint(e.value.toString());
                          if(e.value.toString().isNotEmpty){
                            var offsetMap = Map<String, dynamic>.from(e.value);
                            if(offsetMap.toString()=='{End: 0}'){
                              return null;
                            }
                            else{
                              var offset = Offset(offsetMap['x'].toDouble() ??0.0, offsetMap['y'].toDouble() ??0.0);
                              var paint = Paint()
                                ..color = Color(offsetMap['color'])
                                ..strokeWidth = offsetMap['strokewidth'].toDouble();
                              return DrawModel(offset, paint);
                            }
                          }
                          else{
                            return null;
                          }
                        }).toList();
                      }
                      return CustomPaint(
                          painter: DrawingPainter(pointslist)
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
                children: [
                if(isDrawing)IconButton(
                  icon: Icon(Icons.color_lens,
                      color: selectedColor),
                  onPressed: () {
                    // selectColor();
                    removeData();
                  },
                ),
                  if(isDrawing)Expanded(
                  child: Slider(
                      min: 1.0,
                      max: 10,
                      label: "Strokewidth $strokeWidth",
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (double value) {
                        strokeWidth = value;
                      }),
                ),
                  if(isDrawing)IconButton(
                  icon: Icon(Icons.layers_clear,
                      color: selectedColor),
                  onPressed: () {
                    removeData();
                  },
                ),
              ]),
          ],
        ));
  }
  void removeData(){
    debugPrint("kkbahi");
    count=100000000;
    pointsCollection.set(null);
  }
}// _DrawState

class DrawingPainter extends CustomPainter{ //declaring our custom painter
  final List<DrawModel?> pointsList;

  DrawingPainter(this.pointsList);

  @override
  void paint(Canvas canvas, Size size) { // this is responsible for drawing
    for(int i=0;i<pointsList.length-1;i++){
      if(pointsList[i]!=null && pointsList[i+1]!=null){
        canvas.drawLine(pointsList[i]!.offset, pointsList[i+1]!.offset, pointsList[i]!.paint);
      }
      else if(pointsList[i]!=null && pointsList[i+1]==null){
        List<Offset> offsetList = [];
        offsetList.add(pointsList[i]!.offset);
        canvas.drawPoints(PointMode.points, offsetList, pointsList[i]!.paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawModel{
  final Offset offset;
  final Paint paint;
  DrawModel(this.offset, this.paint);
}
