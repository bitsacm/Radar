import 'package:Radar/utils/Failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  static final AuthRepository _authRepository = new AuthRepository._internal();
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;
  static FlutterSecureStorage _secureStorage;

  factory AuthRepository(FlutterSecureStorage secureStorage) {
    _secureStorage = secureStorage;
    return _authRepository;
  }

  AuthRepository._internal() {
    _googleSignIn = GoogleSignIn();
    _auth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> signInUsingGoogle() async {
    var googleUser = await _googleSignIn.signIn();
    try {
      var googleSignInAuthentication = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      _secureStorage.write(key: 'UID', value: user.uid);
      _secureStorage.write(key: 'UserName', value: user.displayName);
      _secureStorage.write(key: 'Avatar', value: user.photoUrl);
      return user;
    } catch(e) {
      throw Failure('Unable to Login. Please try again.');
    }
  }
}
