import 'package:flutter/material.dart';

class MyRequestBar extends StatelessWidget {
  final myRequestTitle;
  final Function cancelMyRequest;
  MyRequestBar({@required this.myRequestTitle, @required this.cancelMyRequest});
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
              myRequestTitle,
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
              onPressed: cancelMyRequest,
            ),
          ],
        ),
      ),
    );
  }
}
