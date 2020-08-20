import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future logOut() async {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  await _secureStorage.write(key: 'UID', value: null);
  _secureStorage.write(key: 'UserName', value: null);
  _secureStorage.write(key: 'Avatar', value: null);
  await _googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();
}
