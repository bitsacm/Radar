import 'package:flutter/material.dart';

class ConnectedDialog extends StatelessWidget {
  final bool ownRequest;
  ConnectedDialog({@required this.ownRequest});
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
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              child: ownRequest
                  ? Text(
                      'Your request has been accepted! You two can now chat.')
                  : Text(
                      'The selected request has been accepted. You two can now chat.'),
              alignment: Alignment.centerLeft,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Proceed'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
