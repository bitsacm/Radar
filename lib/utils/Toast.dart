import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToast(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    backgroundColor: Colors.black.withOpacity(0.6),
    fontSize: 16,
  );
}
