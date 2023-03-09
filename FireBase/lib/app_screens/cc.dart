import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Draw extends StatefulWidget{
  // final CollectionReference roomParticipants;
  String roomId;
  // final pointsColl;
  // final CollectionReference points;
  Draw({required this.roomId});
  @override
  _DrawState createState() => _DrawState(roomId: roomId,);

}
class _DrawState extends State<Draw>{
  // final CollectionReference roomParticipants;
  String roomId;
  List<DrawModel?> pointsList = [];
  // final pointsStream = BehaviorSubject<List<DrawModel?>>(); // acts as a stack
  GlobalKey key =GlobalKey();
  bool _isDrawing = false;
  // DatabaseReference pointsCollection = FirebaseDatabase.instance.reference();
  int count=100000000;
  int i=0;
  List<DrawModel?> pointslist=[];
  // final pointsColl;



  _DrawState({required this.roomId,});
  DatabaseReference database = FirebaseDatabase.instance.refFromURL('https://playerroom-e0b9d-default-rtdb.asia-southeast1.firebasedatabase.app');
  late final pointsCollection ;

  @override
  void initState() {
    pointsCollection= database.child('Points/points$roomId');
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
        body: GestureDetector(
          onPanDown: (details){
            setState(() {
              //we want to access the low-level layout and painting properties of the widget we are casting the RenderObject method's result as RenderBox
              RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
              Paint paint = Paint(); //creating a paint object
              //assigning properties
              paint.color = Colors.black87;
              paint.strokeWidth = 7.0;
              paint.strokeCap = StrokeCap.round;
              pointsList.add(DrawModel(renderBox.globalToLocal(details.globalPosition), paint));
              // pointsStream.add(pointsList);
              //add to database
              _addpointslist(pointsList.last!);
              // draw();
              _isDrawing = true;
            });
          },
          onPanUpdate: (details){
            RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
            Paint paint = Paint();
            paint.color = Colors.black87;
            paint.strokeWidth = 7.0;
            paint.strokeCap = StrokeCap.round;
            pointsList.add(DrawModel(renderBox.globalToLocal(details.globalPosition), paint));
            // pointsStream.add(pointsList);
            //add to database
            _addpointslist(pointsList.last!);
            // draw();
          },
          onPanEnd: (details){
            // pointsList.forEach((point) {
            //   debugPrint('offset=${point!.offset}, paint=${point.paint}');
            // });
            setState(() {
              pointsList.add(null);
              _addpointslist(pointsList.last);
              // pointsStream.add(pointsList);
              _isDrawing = false;
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
                // Map<String, dynamic> data = (snapshot.data!.value as Map<String, dynamic>);
                // debugPrint(dataList.toString());
                // debugPrint(data.toString());
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
                          ..color = Color(3707764736)
                          ..strokeWidth = 7;
                        return DrawModel(offset, paint);
                      }
                    }
                    else{
                      return null;
                    }
                  }).toList();
                }
                // pointslist.forEach((point) {
                //   if(point==null){
                //     debugPrint('null');
                //   }else {
                //     debugPrint('offset=${point!.offset}, paint=${point.paint}');
                //   }
                // });
                return CustomPaint(
                    painter: DrawingPainter(pointslist)
                );
              },
            ),
          ),
        ));
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
        //drawLine(postion 1(x,y),postion 2(x,y), paint)
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
