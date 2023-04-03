import 'package:flutter/material.dart';

class states extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return states_view();
  }
}
class states_view extends State<states>{
  String anime=" ";
  var animelist = ["Naruto","Attack on Titans","Spy Family"];
  String? currentItemSelected="Naruto";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stateful App Example"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              // onChanged can be also used but the changes are directly reflected on the screen without submitting
              onSubmitted: (String userInput){
                setState(() {
                  anime = userInput;
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: DropdownButton<String>(
                  items: animelist.map((String dropdownStringItem){
                    return DropdownMenuItem(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem)
                    );
                  }).toList(),
                  onChanged: (String? newValuedSelected){
                    _onDropDownItemSelected(newValuedSelected!);
                  },
                  value: this.currentItemSelected,
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  "Anime way : $anime",
                  style: TextStyle(fontSize: 30.0),
                )
            )
          ],
        ),
      ),
    );
  }
  void _onDropDownItemSelected(String newValuedSelected){
    setState(() {
      this.currentItemSelected = newValuedSelected;
    });
  }
}