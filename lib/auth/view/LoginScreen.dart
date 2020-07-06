import 'package:Radar/auth/model/LoginScreenController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final FlutterSecureStorage _secureStorage;
  LoginScreen(this._secureStorage);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Consumer<LoginScreenController>(
          builder: (context, controller, _) {
            if (controller.screenState == LoginScreenState.Initial) {
              return Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      controller.signInUser();
                    },
                    color: Colors.blueAccent,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Login with Google',
                                style: TextStyle(color: Colors.white))
                          ],
                        )),
                  ));
            } else if (controller.screenState == LoginScreenState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return controller.user.fold((failure) {
                print('Failure: ${failure.message}');
                Fluttertoast.showToast(msg: failure.message);
                return Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      controller.signInUser();
                    },
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.account_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Login with Google',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                );
              }, (user) {
                _secureStorage.write(key: 'UID', value: user.uid);
                print('Login Sucessfull ${user.displayName}');
                Fluttertoast.showToast(msg: 'Login Sucess ${user.displayName}');
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/');
                });
                return Container();
              });
            }
          },
        ),
      ),
    );
  }
}
