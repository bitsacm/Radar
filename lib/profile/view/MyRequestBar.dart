import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:flutter/material.dart';

class MyRequestBar extends StatelessWidget {
  final RequestsController _controller;
  MyRequestBar(this._controller);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _controller.roles.requestCreater.requestTitle,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.stop,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () => _controller.cancelMyRequest(),
            ),
          ],
        ),
      ),
    );
  }
}
