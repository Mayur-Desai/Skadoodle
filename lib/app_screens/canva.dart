import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class Draw extends StatefulWidget{
  // final CollectionReference roomParticipants;
  // String roomId;
  // final CollectionReference points;
  // Draw({required this.roomParticipants,required this.roomId,required this.points});
  @override
  _DrawState createState() => _DrawState();

}
class _DrawState extends State<Draw>{
  // final CollectionReference roomParticipants;
  // String roomId;
  List<DrawModel?> pointsList = [];
  // final pointsStream = BehaviorSubject<List<DrawModel?>>(); // acts as a stack
  GlobalKey key =GlobalKey();
  bool _isDrawing = false;
  // final CollectionReference pointsCollection;
  int count=100000000;
  // IOWebSocketChannel channel = IOWebSocketChannel.connect('wss://192.168.1.104:17508');
  late IO.Socket socket;

  @override
  void initState(){
    connect();
  }
  void connect(){
    socket = IO.io("http://192.168.1.104:7500",<String,dynamic>{
      "transports":["websocket"],
      "autoconnect":false,
    });
    socket.connect();
    socket.emit("message","hello world");
    // socket.onConnect((data) => debugPrint("connected"));
    // debugPrint((socket.connected).toString());
  }

  // void _sendData(DrawModel data) {
  //   String jsonData = jsonEncode({
  //     'type': 'DRAW',
  //     'data': {
  //       'x': data.offset.dx,
  //       'y': data.offset.dy,
  //       'color': data.paint.color.value,
  //       'strokewidth': data.paint.strokeWidth
  //     }
  //   });
  //   channel.sink.add(jsonData);
  // }
  @override
  void dispose() {
    // channel.sink.close();
    socket.dispose();
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
              // pointsStream.add(pointsList);
              //add to database
              // _addpointslist(pointsList.last!);
              // _sendData(pointsList.last!);
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
            // _addpointslist(pointsList.last!);
            // _sendData(pointsList.last!);
          },
          onPanEnd: (details){
            // pointsList.forEach((point) {
            //   debugPrint('offset=${point!.offset}, paint=${point.paint}');
            // });
            setState(() {
              pointsList.add(null);
              // _addpointslist(pointsList.last!);
              // pointsStream.add(pointsList);
              _isDrawing = false;
            });
          },

          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

          //   child: StreamBuilder(
          //     stream: channel.stream,
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return CustomPaint(
          //           painter: DrawingPainter(pointsList),
          //         );
          //       }
          //       dynamic data = jsonDecode(snapshot.data.toString());
          //       if (data['type'] == 'DRAW') {
          //         Map<String, dynamic> drawData = data['data'];
          //         pointsList.add(DrawModel(
          //           Offset(drawData['x'], drawData['y']),
          //           Paint()
          //             ..color = Color(drawData['color'])
          //             ..strokeWidth = drawData['strokewidth'],
          //         ));
          //       }
          //       // pointsList.forEach((point) {
          //       //   debugPrint('offset=${point!.offset}, paint=${point.paint}');
          //       // });
          //       pointsList.add(null);
          //       return CustomPaint(
          //         painter: DrawingPainter(pointsList),
          //       );
          //     },
          //   ),
          ),
        ));
  }
  // void dd(){
  //   channel.stream.listen((event) {
  //     debugPrint(event.toString());
  //   });
  // }
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

