import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
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
              Icons.info,
              color: Color.fromARGB(255, 22, 86, 189),
              size: 60,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Log out now?',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, 'logout');
                  },
                  child: Text('Ok'),
                ),
                SizedBox(width: 16),
                FlatButton(
                  color: Color.fromARGB(255, 22, 86, 189),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
