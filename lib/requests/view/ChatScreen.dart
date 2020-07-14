import 'package:Radar/requests/controller/RequestsController.dart'
    as requestsController;
import 'package:Radar/requests/view/ChatInput.dart';
import 'package:Radar/requests/view/ChatItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<requestsController.RequestsController>(
          builder: (context, _controller, child) {
            if (_controller.connectionState !=
                requestsController.ConnectionState.Connected) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
            }

            return Column(
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
            );
          },
        ),
      ),
    );
  }
}
