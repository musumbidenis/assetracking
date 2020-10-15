import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

alert(String message, Color backgroundColor, context) {
  Flushbar(
    message: message,
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: Colors.white,
    ),
    duration: Duration(seconds: 8),
    backgroundColor: backgroundColor,
  )..show(context);
}
