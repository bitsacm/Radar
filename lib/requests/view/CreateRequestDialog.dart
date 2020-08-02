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
        child: SingleChildScrollView(
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
              Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Text(
                        'Title:',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w600),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    //width: 200,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xffF5F2F2),
                        hintText: "Request Title",
                        hintStyle: TextStyle(fontSize: 14),
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
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        child: Text(
                          'Description:',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        //width: 200,
                        child: TextField(
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffF5F2F2),
                            hintText: "Request Description",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          controller: _descriptionController,
                          textInputAction: TextInputAction.newline,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
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
      ),
    );
  }
}
