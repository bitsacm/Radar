import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future logOut()async{
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  await _secureStorage.delete(key: 'UID');
  await _secureStorage.delete(key: 'UserName');
  await _secureStorage.delete(key: 'Avatar');
  await _auth.signOut();
  await _googleSignIn.signOut();
}