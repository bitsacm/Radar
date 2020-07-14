import 'package:Radar/requests/model/Message.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final Message _message;
  ChatItem(this._message);
  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle recievedMessageStyle = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle myMessageStyle = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Bubble(
      style: _message.ownMessage ? myMessageStyle : recievedMessageStyle,
      child: Text(
        _message.text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
