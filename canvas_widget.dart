import 'dart:ui';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class Draw extends StatefulWidget{
  @override
  _DrawState createState() => _DrawState();
  
}
class _DrawState extends State<Draw>{
  List<DrawModel?> pointsList = [];
  final pointsStream = BehaviorSubject<List<DrawModel?>>(); // acts as a stack
  GlobalKey key =GlobalKey();
  bool _isDrawing = false;
  //closing the BehaviorSubject
  @override
  void dispose(){
    pointsStream.close();
    super.dispose();
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
            pointsStream.add(pointsList);
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
          pointsStream.add(pointsList);
        },
        onPanEnd: (details){
          // pointsList.forEach((point) {
          //   debugPrint('offset=${point!.offset}, paint=${point.paint}');
          // });
          setState(() {
            pointsList.add(null);
            pointsStream.add(pointsList);
            _isDrawing = false;
          });
        },

      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: StreamBuilder<List<DrawModel?>>(
          stream: pointsStream.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: DrawingPainter((snapshot.data??[])),
            );
          }
        ),
      ),
    ));
  }
}
class DrawingPainter extends CustomPainter{ //declaring our custom painter
  final List<DrawModel?> pointsList;

  DrawingPainter(this.pointsList);

  @override
  void paint(Canvas canvas, Size size) { // this is responsible for drawing
    for(int i=0;i<pointsList.length;i++){
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