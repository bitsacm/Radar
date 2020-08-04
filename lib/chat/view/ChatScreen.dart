import 'package:Radar/chat/model/Message.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/chat/view/ChatAppBar.dart';
import 'package:Radar/chat/view/ChatInput.dart';
import 'package:Radar/chat/view/ChatItem.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final _controller;
  ChatScreen(this._controller);

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    List<Message> messages;
    if (_controller is RequestsController) {
      title = _controller.acceptedRequest.title;
      description = _controller.acceptedRequest.description;
      messages = _controller.connectedUsers.requestAccepter.messages;
    } else {
      title = _controller.myRequest.title;
      description = _controller.myRequest.description;
      messages = _controller.connectedUsers.requestCreater.messages;
    }
    return Scaffold(
      appBar: ChatAppBar(title, description),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => ChatItem(messages[index]),
                itemCount: messages.length,
              ),
            ),
            ChatInput(_controller),
          ],
        ),
      ),
    );
  }
}
