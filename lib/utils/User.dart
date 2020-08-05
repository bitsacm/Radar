import 'package:Radar/utils/ConnectionState.dart';
import '../chat/model/Message.dart';

class User {
  String endpointId;
  List<Message> messages = [];
  Message currentMessage;
  ConnectionState connectionState = ConnectionState.Disconnected;
  String requestTitle;
  String requestDescription;

  User({this.endpointId});

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

  void clearMessages() {
    messages.clear();
    currentMessage = null;
  }
}
