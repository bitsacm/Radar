import 'package:flutter/material.dart';
import 'package:Radar/utils/Toast.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController _inputController = TextEditingController();
  final Function sendMessage;
  ChatInput({@required this.sendMessage});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                controller: _inputController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  String msg = _inputController.text.trim();
                  if (msg.isNotEmpty && msg.length > 0) {
                    sendMessage(_inputController.text);
                  } else {
                    displayToast('Message cannot be empty');
                  }
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }
}
