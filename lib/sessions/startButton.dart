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

  String id;
  String barcode;
  String lab;

  ///Styling for texts///
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
      body:
          /////Start button/////
          Center(
        child: Container(
          width: 250.0,
          height: 50.0,
          child: FloatingActionButton.extended(
            elevation: 0.0,
            label: Text(
              _isLoading ? "Starting.." : "Start",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: startSession,
          ),
        ),
      ),
    );
  }

//////Handles initialization of session////////
  Future startSession() async {
    //Set button state to loading//
    setState(() {
      _isLoading = true;
    });

    //Send data to db//
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    id = localStorage.getString('userKey');
    lab = localStorage.getString('labKey');
    barcode = localStorage.getString('barcodeKey');

    var data = {
      'id': id,
      'barcode': barcode,
      'lab': lab,
    };

    //Post Start Session data to db via API//
    var response = await CallAPi().postData(data, 'start');
    var body = json.decode(response.body);
    print(body);
    if (body == 'success') {
      //Navigate to stop page//
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Stop(),
        ),
      );

      //Redirect with success message//
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
      //Set button loading state to false//
      setState(() {
        _isLoading = false;
      });

      //Redirect with error message//
      Flushbar(
        message: 'Session not started.Please try again!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 30),
        backgroundColor: Colors.redAccent,
      )..show(context);
    }
  }
}
