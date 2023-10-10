import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat.dart';
import '../providers/account.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<List<Message>> _listMessages() async {
    final chat = context.read<Chat>();

    await chat.list();

    _scrollDown();

    return _messages;
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final chat = context.read<Chat>();
      final account = context.read<Account>();

      await chat.send(Message(
        user: account.user!.name,
        message: _controller.text,
      ));

      _controller.clear();
    }
  }

  void _scrollDown() {
    if(_scrollController.positions.isEmpty) {
      return;
    }
    // Scroll to the bottom of the list
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  String _formatMessage(Message message) {
    return '${message.user}: ${message.message}';
  }

  Future<void> _jumpTo() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    _messages = context.watch<Chat>().messages;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(20),  
        child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _listMessages(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  _jumpTo();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Text(_formatMessage(_messages[index]));
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
      )    
    );
  }
}
