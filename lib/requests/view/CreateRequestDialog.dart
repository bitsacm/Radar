import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateRequestDialog extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Create Request',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              children: <Widget>[
                Text('Title:'),
                Container(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Request Title",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text('Description:'),
                Container(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Request Description",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    controller: _descriptionController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RaisedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _descriptionController.text.isEmpty)
                    Fluttertoast.showToast(
                      msg: 'Both fields are neccesary',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  else {
                    Navigator.pop(context, {
                      'title': _titleController.text,
                      'description': _descriptionController.text
                    });
                  }
                },
                child: Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
