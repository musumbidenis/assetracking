import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const Alert({Key key, @required this.message, @required this.backgroundColor})
      : super(key: key);

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return Flushbar(
      message: widget.message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.white,
      ),
      duration: Duration(seconds: 8),
      backgroundColor: widget.backgroundColor,
    )..show(context);
  }
}
