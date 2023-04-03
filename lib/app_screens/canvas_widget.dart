import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';


class Draw extends StatefulWidget{
  final CollectionReference roomParticipants;
  String roomId;
  final CollectionReference points;
  Draw({required this.roomParticipants,required this.roomId,required this.points});
  @override
  _DrawState createState() => _DrawState(roomParticipants: roomParticipants,roomId: roomId,pointsCollection: points);
  
}
class _DrawState extends State<Draw>{
  final CollectionReference roomParticipants;
  String roomId;
  List<DrawModel?> pointsList = [];
  // final pointsStream = BehaviorSubject<List<DrawModel?>>(); // acts as a stack
  GlobalKey key =GlobalKey();
  bool _isDrawing = false;
  final CollectionReference pointsCollection;
  int count=100000000;
  int i=0;
  List<DrawModel?> pointslist=[];



  _DrawState({required this.roomParticipants,required this.roomId,required this.pointsCollection});


  // @override
  // void initState() {
  //   draw();
  // }

  Future<void> _addpointslist(DrawModel? points) async {
    try{
      if(points==null){
        await pointsCollection.doc((count++).toString()).set({
          'null':null,
        });
      }
      else {
        await pointsCollection.doc((count++).toString()).set({
          'x': points.offset.dx,
          'y': points.offset.dy,
          'color': points.paint.color.value,
          'strokewidth': points.paint.strokeWidth
        });
      }
    }catch(e){
      debugPrint(e.toString());
    }
  }
//   Future<void> _markasend() async {
//     try{
//       await pointsCollection.doc((count++).toString()).set({
//
//       });
//     }catch(e){
//
//     }
// }

  //closing the BehaviorSubject
  // @override
  // void dispose(){
  //   pointsStream.close();
  //   super.dispose();
  // }
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
          //globalTolocal - converting a point from global coordinates to local coordinates
          //The globalPosition property is a Offset object that contains two properties, dx and dy,
          // representing the horizontal and vertical coordinates of the touch event, respectively
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

        // child: StreamBuilder<List<DrawModel?>>(
        //   stream: pointsStream.stream,
        //   builder: (context, snapshot) {
        //     return CustomPaint(
        //       painter: DrawingPainter((snapshot.data??[])),
        //     );
        //   }
        // ),
        child: StreamBuilder<QuerySnapshot?>(
          // stream: FirebaseFirestore.instance
          //     .collection('points$roomId')
          //     .orderBy(FieldPath.documentId, descending: false)
          //     .snapshots(),
          stream: pointsCollection.snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return CustomPaint(
                painter: DrawingPainter(pointsList),
              );
            }
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            pointslist = documents.map((doc) {
              // debugPrint(doc.id.toString());
              if(doc.data().toString()=='{null: null}'){
                return null;
              }
              else{
                return DrawModel(
                  Offset(doc.get('x'),doc.get('y')),
                  Paint()
                    ..color = Color(doc.get('color'))
                    ..strokeWidth = doc.get('strokewidth'),
                );
              }
            }).toList();

            // while(i<documents.length){
            //   // debugPrint(i.toString());
            //   DocumentSnapshot doc = documents[i];
            //   pointslist.add(DrawModel(
            //           Offset(doc.get('x'),doc.get('y')),
            //           Paint()
            //             ..color = Color(doc.get('color'))
            //             ..strokeWidth = doc.get('strokewidth'),
            //       ));
            //   i++;
            // }
            // pointslist.add(null);
            // pointsList.forEach((point) {
            //   debugPrint('offset=${point!.offset}, paint=${point.paint}');
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