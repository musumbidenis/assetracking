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
  String id;
  String barcode;
  int lab;

  ///Styling for texts///
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "Start",
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 30.0,
                ),
                onPressed: () {},
              ),
            ),
          ]),
      body:
          /////Start button/////
          Center(
        child: Container(
          width: 250.0,
          height: 50.0,
          child: FloatingActionButton.extended(
            elevation: 0.0,
            label: Text(
              "Start",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: startSession,
          ),
        ),
      ),
    );
  }

  Future startSession() async {
    //Send data to db//
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    id = localStorage.getString('userKey');
    lab = localStorage.getInt('labKey');
    barcode = localStorage.getString('barcodeKey');

    print(id);
    print(barcode);
    print(lab);
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Stop(),
        ),
      );
      //Confirmation message//
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
      Flushbar(
        message: 'Session not started!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      )..show(context);
    }
  }
}
