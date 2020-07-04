import 'package:Radar/auth/model/LoginScreenController.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ChangeNotifierProvider<LoginScreenController>(
          create: (BuildContext context) => LoginScreenController(),
          child: Consumer<LoginScreenController>(
            builder: (context, controller, _) {
              if (controller.screenState == LoginScreenState.Initial) {
                return Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
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
                            Icon(
                                Icons.account_circle,
                                color: Colors.white),
                            SizedBox(width: 10),
                            Text('Login with Google',
                                style: TextStyle(color: Colors.white))
                          ],
                        )
                      ),
                  )
                );
              } else if (controller.screenState == LoginScreenState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return controller.user.fold(
                  (failure) {
                    print('Failure: ${failure.message}');
                    Fluttertoast.showToast(msg: failure.message);
                    return Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
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
                                Icon(
                                    Icons.account_circle,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text('Login with Google',
                                    style: TextStyle(color: Colors.white))
                              ],
                            )
                          ),
                      )
                    );
                  }, 
                  (user)  {
                    print('Login Sucessfull ${user.displayName}');
                    Fluttertoast.showToast(msg: 'Login Sucess ${user.displayName}');
                    return Container();
                  }
                );
              }
            }
          ),
        ),
      ),
    );
  }
}