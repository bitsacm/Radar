import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/chat/view/ChatAppBar.dart';
import 'package:Radar/chat/view/ChatInput.dart';
import 'package:Radar/chat/view/ChatItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final  _controller;
  final String title;
  final String description;
  ChatScreen(this._controller, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(title, description),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    ChatItem(_controller.messages[index]),
                itemCount: _controller.messages.length,
              ),
            ),
            ChatInput(_controller),
          ],
        ),
      ),
    );
  }
}

// class ChatScreen2 extends StatelessWidget {
//   final ProfileController _controller;
//   final String title;
//   final String description;
//   ChatScreen2(this._controller, this.title, this.description);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ChatAppBar(title, description),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Flexible(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(10.0),
//                 itemBuilder: (context, index) =>
//                     ChatItem(_controller.messages[index]),
//                 itemCount: _controller.messages.length,
//               ),
//             ),
//             ChatInput(_controller),
//           ],
//         ),
//       ),
//     );
//   }
// }
