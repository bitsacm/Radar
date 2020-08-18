import 'package:Radar/utils/ConnectionState.dart' as util;
import 'package:flutter/material.dart';
import '../chat/model/Message.dart';

class Role {
  String endpointId;
  List<Message> messages = [];
  Message currentMessage;
  util.ConnectionState connectionState = util.ConnectionState.Disconnected;
  String requestTitle;
  String requestDescription;
  Function sendMessage;
  bool shownDisconnectedDialog;
  bool shownConnectedDialog;

  void addRequestDetails(String title, String description) {
    requestTitle = title;
    requestDescription = description;
  }

  void clearRequestDetails() {
    requestTitle = null;
    requestDescription = null;
  }

  bool doRequestDetailsExist() {
    if (requestTitle != null || requestDescription != null)
      return true;
    else
      return false;
  }

  void connect({@required String endpointId, @required Function sendMessage}) {
    this.endpointId = endpointId;
    connectionState = util.ConnectionState.Connected;
    shownDisconnectedDialog = false;
    shownConnectedDialog = false;
    this.sendMessage = sendMessage;
  }

  void disconnect() {
    messages.clear();
    currentMessage = null;
    sendMessage = null;
    endpointId = null;
    connectionState = util.ConnectionState.Disconnected;
  }
}
