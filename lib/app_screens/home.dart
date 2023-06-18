import "package:flutter/material.dart";

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey,
          // width: 350.0,
          // height: 470.0,
          // margin: EdgeInsets.all(20.0),// this is used to provide margins on all four sides
          // margin: EdgeInsets.only(right: 30.0,left: 20.0,top:50.0),
            padding: EdgeInsets.only(left: 10.0,top: 50.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(
                    "Sup Bro!",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none, // by default it'll be underline
                        fontSize: 50.0,
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic
                    ),
                  )),
                  Expanded(child: Text(
                    "It's February",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      decoration: TextDecoration.none,
                      fontSize: 35.0,
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text(
                    "Buddy!",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none, // by default it'll be underline
                        fontSize: 50.0,
                        fontFamily: "Rajdhani",
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic
                    ),
                  )),
                  Expanded(child: Text(
                    "It's March",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      decoration: TextDecoration.none,
                      fontSize: 35.0,
                      fontFamily: "Rajdhani",
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                ],
              ),
              ImageAssest(),
              ReactButton()
            ],
          )
        )
    );
  }
}
class ImageAssest extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/frds.png');
    Image image = Image(image: assetImage);
    return Container(
        child: image,
        padding: EdgeInsets.only(top: 50.0),
    );
  }
}
class ReactButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButton = ElevatedButton.styleFrom(
      primary: Colors.teal,
      side: BorderSide(color: Colors.white54,width: 2.0),
      textStyle: TextStyle( color: Colors.white,fontSize: 25.0,fontFamily: "Rajdhani",fontWeight: FontWeight.w700)
    );
    AssetImage assetImage = AssetImage('images/emot.png');
    Image image2 = Image(image: assetImage);
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: ElevatedButton(
        style: raisedButton,
        onPressed: () => showContnet(context),
        child: Text("Press this!"),
        // child: image2, // adding a emoji inside a button
      )
    );
  }
  void showContnet(BuildContext context){
    var alertDialog = AlertDialog(
      title: Text("NO BRO!"),
      content: Text("It's Friday"),
    );

    showDialog(
        context: context,
        builder: (BuildContext content) => alertDialog
    );
  }
}