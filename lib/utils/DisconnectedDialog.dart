import 'package:flutter/material.dart';

class DisconnectedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.not_interested,
              color: Colors.red,
              size: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              child: Text(
                'Seems like one of you was disconnected. You will be taken back to the requests page.',
              ),
              alignment: Alignment.centerLeft,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
