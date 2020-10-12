import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/chat/view/ChatInput.dart';
import 'package:Radar/chat/view/ChatItem.dart';
import 'package:Radar/chat/view/ChatAppBar.dart';
import 'package:Radar/utils/DisconnectedDialog.dart';
import 'package:Radar/utils/Role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class ChatScreen extends StatelessWidget {
  final _schedulerBinding = SchedulerBinding.instance;
  @override
  Widget build(BuildContext context) {
    final _routeName = ModalRoute.of(context).settings.name;
    Role _role;

    return Consumer<RequestsController>(
      builder: (context, _requestsController, child) {
        ScrollController _scrollController = ScrollController();

        if (_routeName == '/requestAccepterChat') {
          _role = _requestsController.roles.requestAccepter;
        } else {
          _role = _requestsController.roles.requestCreater;
        }

        if (_role.connectionState != util.ConnectionState.Connected && _role.shownDisconnectedDialog == false) {
          _schedulerBinding.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => DisconnectedDialog(),
            ).whenComplete(() {
              if (_routeName == '/requestAccepterChat') {
                _requestsController.roles.requestAccepter.shownDisconnectedDialog = true;
              } else {
                _requestsController.roles.requestCreater.shownDisconnectedDialog = true;
              }
              Navigator.of(context).popUntil(
                ModalRoute.withName('/home'),
              );
            });
            return Container();
          });
        }

        _schedulerBinding.addPostFrameCallback((_) {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        });
        return Scaffold(
          // appBar: ChatAppBar(
          //   title: _role.requestTitle,
          //   description: _role.requestDescription,
          // ),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 22, 86, 189),
            title: Text(_role.requestTitle ?? 'Request title'),
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline_rounded),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(_role.requestTitle ?? 'Request title'),
                      children: [
                        Text(_role.requestTitle ??
                            'Laudantium sit quis voluptatibus non. Vel cupiditate enim eos eum dolorem. Natus ea veritatis porro ut quos consequatur. Qui praesentium ex vero cupiditate explicabo voluptas est.'),
                      ],
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                  );
                },
              ),
            ],
            toolbarHeight: 56,
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => ChatItem(
                    message: _role.messages[index],
                  ),
                  itemCount: _role.messages.length,
                  controller: _scrollController,
                ),
              ),
              ChatInput(
                sendMessage: _role.sendMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}
