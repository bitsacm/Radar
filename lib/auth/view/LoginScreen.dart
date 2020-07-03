import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Align(
          alignment: Alignment.center,
          child: FlatButton(
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
               ),
               onPressed: () {
                  // TODO: Implement on click functionality
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
        ),
      ),
    );
  }
}