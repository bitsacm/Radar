import 'package:Radar/utils/Roles.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

class ProfileController with ChangeNotifier {
  final Nearby _nearby = Nearby();
  final Roles roles;
  ProfileController(this.roles);

  void cancelMyRequest() async {
    roles.requestCreater.clearRequestDetails();
    await _nearby.stopAdvertising();
    notifyListeners();
  }
}
