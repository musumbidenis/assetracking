import 'dart:convert';

import 'package:assetracking/API/api.dart';
import 'package:assetracking/sessions/stop.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartButton extends StatefulWidget {
  @override
  _StartButtonState createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool _isLoading = false;
  bool _isDisabled = true;

  String id;
  String barcode;

  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Start Button",
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          width: 250.0,
          height: 50.0,
          child: FloatingActionButton.extended(
            elevation: 0.0,
            label: Text(
              _isLoading ? "Starting.." : "Start",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: _isDisabled ? null : startSession,
          ),
        ),
      ),
    );
  }

/*Handles session initialization */
  Future startSession() async {
    setState(() {
      _isLoading = true;
      _isDisabled = false;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    id = localStorage.getString('userKey');
    barcode = localStorage.getString('barcodeKey');

    var data = {
      'id': id,
      'barcode': barcode,
    };

    /*Sends data to database */
    var response = await CallAPi().postData(data, 'start');
    var body = json.decode(response.body);

    if (body == 'success') {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Stop(),
        ),
      );

      /* Success message */
      Flushbar(
        message: 'Session started successfully!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.greenAccent,
      )..show(context);
    } else {
      setState(() {
        _isLoading = false;
      });

      /* Error message */
      Flushbar(
        message: 'Asset not valid. Please choose a valid asset in record!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 8),
        backgroundColor: Colors.redAccent,
      )..show(context);
    }
  }
}
