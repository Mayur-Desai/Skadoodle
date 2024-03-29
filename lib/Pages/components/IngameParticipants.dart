import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skadoodlem/model/Gamer.dart';
import 'package:skadoodlem/model/user_model.dart';

class InGameplayerTile extends StatelessWidget {
  final Gamer gamer;
  bool iswaiting;
  final CollectionReference roomParticipants;
  bool isAdmin;
  InGameplayerTile({required this.gamer,required this.iswaiting,required this.roomParticipants,required this.isAdmin,});
  //List<String> gifs = ['images/annie.gif','images/eren.gif','images/here-cute.gif','images/Jean.gif','images/Jean2.gif','images/levi.gif','images/mikasa.gif','images/sasha.gif'];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return Padding(
      padding: EdgeInsets.only(top: 0.0),
      child: Card(
        color: gamer.guessed?Colors.green:Colors.tealAccent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(gamer.name,style: TextStyle(fontSize: 17),),
          //leading: ImageAssest(img:gifs[gamer.index]),
          leading: ImageAssest(img: 'images/mik.gif'),
          subtitle: iswaiting==false?Text("Pts:"+gamer.points.toString()):Text(''),
          trailing: iswaiting==false?Text(gamer.rank.toString(),style: TextStyle(fontWeight:FontWeight.bold,),):(!isAdmin)?Text(""):
          IconButton(
            icon: Icon(Icons.group_remove),
            onPressed: ()  {
              roomParticipants.doc(user?.userUid).delete();//wtf?!?
              if(isAdmin==true){
                Navigator.pop(context);
              }
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
class ImageAssest extends StatelessWidget{
  String img;
  ImageAssest({required this.img});
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage(img);
    Image image = Image(image: assetImage);
    return Container(
      child: image,
      // padding: EdgeInsets.only(top: 50.0),
    );
  }
}