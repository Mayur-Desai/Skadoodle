import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/authenticate.dart';
import './drawing_room.dart';
import '../models/User.dart';
class wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);
    debugPrint(user?.uid);
    if(user == null){
      return authenticate();
    }else{
      return room();
    }
    //returns either home or authentication widget
  }
}