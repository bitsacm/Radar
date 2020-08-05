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
      title = _controller.connectedUsers.requestAccepter.requestTitle;
      description =
          _controller.connectedUsers.requestAccepter.requestDescription;
      messages = _controller.connectedUsers.requestAccepter.messages;
    } else {
      title = _controller.connectedUsers.requestCreater.requestTitle;
      description =
          _controller.connectedUsers.requestCreater.requestDescription;
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
            ChatInput(_controller.sendMessage),
          ],
        ),
      ),
    );
  }
}
