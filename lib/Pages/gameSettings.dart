import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skadoodlem/Pages/WaitingRoom.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:skadoodlem/Buttons/NextButton.dart';
class GameSettings extends StatefulWidget {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  GameSettings({required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});
  @override
  State<GameSettings> createState() => _GameSettingsState(roomParticipants: roomParticipants,roomId: roomId,isAdmin: isAdmin,Name: Name);
}
class _GameSettingsState extends State<GameSettings> {
  final CollectionReference roomParticipants;
  String roomId;
  bool isAdmin;
  String Name;
  _GameSettingsState({required this.roomParticipants,required this.roomId,required this.isAdmin,required this.Name});

  var rounds=3;
  var duration=80;
  var word_count=3;
  var hints=1;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      const SizedBox(height:20),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Text('OPTIONS',
                                style: TextStyle(
                                  color:Colors.blueGrey[400],
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Caveat',
                                )
                            ),
                            const SizedBox(width: 10),
                            Image.asset('images/setting.png',width: 100,height: 80,),
                          ]
                      ),
                    ),
                  ),





                      const SizedBox(height:50),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DropdownSearch<int>(

                          items: const [1,2,3,4,5,6,7,8,9,10],
                          popupProps: PopupPropsMultiSelection.menu(
                            fit:FlexFit.tight,
                            searchFieldProps:const TextFieldProps(

                            ),
                            listViewProps:const ListViewProps(),
                            menuProps:MenuProps(
                              backgroundColor:Colors.brown[200],
                            ),

                            scrollbarProps:const ScrollbarProps(
                                trackVisibility:true,
                                thumbVisibility:true,
                                thumbColor:Colors.blue


                            ),
                            constraints:const BoxConstraints(maxHeight: 365),
                          ),
                          dropdownDecoratorProps:DropDownDecoratorProps(

                            dropdownSearchDecoration: const InputDecoration(

                              labelText: "Rounds",
                              hintText: "Select the Number of Rounds to play",
                              border: OutlineInputBorder(),
                            ),
                            baseStyle:TextStyle(
                              color:Colors.blueGrey[400],
                              fontSize: 26,
                              fontWeight: FontWeight.bold,),

                            textAlign: TextAlign.center
                          ),

                          onChanged: (val) {
                            rounds=val!;
                            print(rounds);

                            },

                          selectedItem: 3,
                        ),
                      ),

                      const SizedBox(height:35),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DropdownSearch<int>(

                          items: const [15,20,30,40,50,60,70,80,90,100,120,150,180,210,240],

                          popupProps: PopupPropsMultiSelection.menu(
                              fit:FlexFit.tight,
                              searchFieldProps:const TextFieldProps(

                              ),
                            listViewProps:const ListViewProps(),
                            menuProps:MenuProps(
                                backgroundColor:Colors.brown[200],
                            ),

                              scrollbarProps:const ScrollbarProps(
                                trackVisibility:true,
                                thumbVisibility:true,
                                  thumbColor:Colors.blue


                              ),
                              constraints:const BoxConstraints(maxHeight: 365),
                          ),
                          dropdownDecoratorProps:DropDownDecoratorProps(

                              dropdownSearchDecoration: const InputDecoration(

                                labelText: "Draw Time (secs)",
                                hintText: "Select the draw time",
                                border: OutlineInputBorder(),
                              ),
                              baseStyle:TextStyle(
                                color:Colors.blueGrey[400],
                                fontSize: 26,
                                fontWeight: FontWeight.bold,),

                              textAlign: TextAlign.center
                          ),

                          onChanged: (val) {
                            duration=val!;
                            print(duration);

                          },

                          selectedItem: 80,
                        ),
                      ),

                      const SizedBox(height:35),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DropdownSearch<int>(

                          items: const [1,2,3],
                          popupProps: PopupPropsMultiSelection.menu(
                            fit:FlexFit.tight,
                            searchFieldProps:const TextFieldProps(

                            ),
                            listViewProps:const ListViewProps(),
                            menuProps:MenuProps(
                              backgroundColor:Colors.brown[200],
                            ),

                            scrollbarProps:const ScrollbarProps(
                                trackVisibility:true,
                                thumbVisibility:true,
                                thumbColor:Colors.blue


                            ),
                            constraints:const BoxConstraints(maxHeight: 170),
                          ),
                          dropdownDecoratorProps:DropDownDecoratorProps(

                              dropdownSearchDecoration: const InputDecoration(

                                labelText: "Word Count",
                                hintText: "Select Number of words to guess",
                                border: OutlineInputBorder(),
                              ),
                              baseStyle:TextStyle(
                                color:Colors.blueGrey[400],
                                fontSize: 26,
                                fontWeight: FontWeight.bold,),

                              textAlign: TextAlign.center
                          ),

                          onChanged: (val) {
                            word_count=val!;
                            print(word_count);

                          },

                          selectedItem: 2,
                        ),
                      ),

                      const SizedBox(height:35),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DropdownSearch<int>(

                          items: const [0,1,2,3,4],
                          popupProps: PopupPropsMultiSelection.menu(
                            fit:FlexFit.tight,
                            searchFieldProps:const TextFieldProps(

                            ),
                            listViewProps:const ListViewProps(),
                            menuProps:MenuProps(
                              backgroundColor:Colors.brown[200],
                            ),

                            scrollbarProps:const ScrollbarProps(
                                trackVisibility:true,
                                thumbVisibility:true,
                                thumbColor:Colors.blue


                            ),
                            constraints:const BoxConstraints(maxHeight: 250),
                          ),
                          dropdownDecoratorProps:DropDownDecoratorProps(

                              dropdownSearchDecoration: const InputDecoration(

                                labelText: "Hints",
                                hintText: "Select Hints",
                                border: OutlineInputBorder(),
                              ),
                              baseStyle:TextStyle(
                                color:Colors.blueGrey[400],
                                fontSize: 26,
                                fontWeight: FontWeight.bold,),

                              textAlign: TextAlign.center
                          ),

                          onChanged: (val) {
                            hints=val!;
                            print(hints);

                          },

                          selectedItem: 1,
                        ),
                      ),

                      const SizedBox(height:65),

                      NextButton(
                        onTap:()async{
                          await roomParticipants.doc("Parameters").update({
                            'rounds':rounds,
                            'duration':duration,
                            'word_count':word_count,
                            'Hints':hints
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: roomId,isAdmin: isAdmin,Name:Name)),
                          );
                        },
                      )




                    ]
                )
              ),


            )

          )


        )
    );








    // return Scaffold(
    //   body: Column(
    //     children: [
    //       TextFormField(
    //         keyboardType: TextInputType.number,
    //         inputFormatters: <TextInputFormatter>[
    //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //         ],
    //         onChanged: (val){
    //           rounds=int.tryParse(val) ?? 0;
    //         },
    //       ),
    //       TextFormField(
    //         keyboardType: TextInputType.number,
    //         inputFormatters: <TextInputFormatter>[
    //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //         ],
    //         onChanged: (val){
    //           duration=int.tryParse(val) ?? 0;
    //         },
    //       ),
    //       TextFormField(
    //         keyboardType: TextInputType.number,
    //         inputFormatters: <TextInputFormatter>[
    //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //         ],
    //         onChanged: (val){
    //           word_count=int.tryParse(val) ?? 0;
    //         },
    //       ),
    //       TextFormField(
    //         keyboardType: TextInputType.number,
    //         inputFormatters: <TextInputFormatter>[
    //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    //         ],
    //         onChanged: (val){
    //           hints=int.tryParse(val) ?? 0;
    //         },
    //       ),
    //       ElevatedButton(
    //           onPressed:()async{
    //             await roomParticipants.doc("Parameters").update({
    //               'rounds':rounds,
    //               'duration':duration,
    //               'word_count':word_count,
    //               'Hints':hints
    //             });
    //             // Navigator.push(
    //             //   context,
    //             //   MaterialPageRoute(builder: (context) => waitingRoom(roomParticipants: roomParticipants,roomId: roomId,isAdmin: isAdmin,Name:Name)),
    //             // );
    //           },
    //           child: Text("CREATE")
    //       )
    //     ],
    //   ),
    // );



  }
}