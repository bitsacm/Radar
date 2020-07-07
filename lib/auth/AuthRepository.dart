import 'package:Radar/utils/Failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  static final AuthRepository _authRepository = new AuthRepository._internal();
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;

  factory AuthRepository() {
    return _authRepository;
  }

  AuthRepository._internal() {
    _googleSignIn = GoogleSignIn();
    _auth = FirebaseAuth.instance;
  }

  Future<FirebaseUser> signInUsingGoogle() async {
    var googleUser = await _googleSignIn.signIn();
    if (googleUser.email.endsWith('@pilani.bits-pilani.ac.in')) {
      var googleSignInAuthentication = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      return (await _auth.signInWithCredential(credential)).user;
    } else {
      await _googleSignIn.signOut();
      throw Failure('Please sign in with BITS Mail');
    }
  }
}
