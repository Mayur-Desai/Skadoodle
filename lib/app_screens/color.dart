import 'package:flutter/material.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // reverse: true,
              controller: _scrollController,
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                title: Text('Chat $index'),
              ),
            ),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Type a message',
            ),
            onSubmitted: (text) {
              _textController.clear();
              // Scroll to the bottom when a new message is sent
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
