import 'package:Radar/utils/Roles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nearby_connections/nearby_connections.dart';

class ProfileController with ChangeNotifier {
  final Nearby _nearby = Nearby();
  final Roles roles;
  final FlutterSecureStorage secureStorage;

  ProfileController(this.roles, this.secureStorage);

  void cancelMyRequest() async {
    roles.requestCreater.clearRequestDetails();
    await _nearby.stopAdvertising();
    notifyListeners();
  }

  Future logout() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final _auth = FirebaseAuth.instance;
    await secureStorage.delete(key: 'UID');
    await secureStorage.delete(key: 'UserName');
    await secureStorage.delete(key: 'Avatar');
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
