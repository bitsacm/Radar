import '../chat/model/Message.dart';

class User {
  String endpointId;
  List<Message> messages = [];
  Message currentMessage;

  User(this.endpointId);
}
