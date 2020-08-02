import 'package:Radar/auth/model/LoginScreenController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        child: Consumer<LoginScreenController>(
          builder: (context, controller, _) {
            if (controller.screenState == LoginScreenState.Initial) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.1066),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/login_screen/lost-items.png',
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "RADAR",
                                  style: TextStyle(
                                    fontFamily: 'Futura Bk Bt',
                                    fontSize: 45,
                                    color: (Colors.amber),
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                            Text(
                              "An Interesting quote.",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                color: Color.fromARGB(255, 22, 86, 189),
                              ),
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                controller.signInUser();
                              },
                              color: Colors
                                  .blueAccent, //This color used is slightly different from the given design.
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.account_circle,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('Login with Google',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    mediaQuery.size.height > 450 //For Landscape Mode
                        ? SizedBox(
                            height: mediaQuery.size.height * 0.21,
                          )
                        : SizedBox.shrink(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: Image.asset(
                            'assets/login_screen/Login Screen Illustration.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
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
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
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
                  ),
                );
              }, (user) {
                print('Login Sucessfull ${user.displayName}');
                Fluttertoast.showToast(msg: 'Login Sucess ${user.displayName}');
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/home');
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
