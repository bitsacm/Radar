import 'package:Radar/auth/AuthRepository.dart';
import 'package:Radar/utils/Failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:Radar/utils/extentions.dart';

enum LoginScreenState {
  Initial,
  Loading,
  Loaded
}

class LoginScreenController extends ChangeNotifier {
  Either<Failure, FirebaseUser> user;
  AuthRepository _authRepository;
  LoginScreenState screenState;

  LoginScreenController() {
    screenState = LoginScreenState.Initial;
    notifyListeners();
    _authRepository = AuthRepository();
  }

  void signInUser() async {
    screenState = LoginScreenState.Loading;
    notifyListeners();
    await Task(() => _authRepository.signInUsingGoogle())
      .attempt()
      .mapLeftToFailure()
      .run()
      .then((result) {
        user = result;
        notifyListeners();
      });
    screenState = LoginScreenState.Loaded;
    notifyListeners();
  }
}