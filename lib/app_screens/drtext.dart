import 'package:flutter/material.dart';
class ChatScreen2 extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen2> {
  final List<String> messages = List.generate(99, (index) => 'Chat $index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}