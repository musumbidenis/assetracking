import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopButton extends StatefulWidget {
  @override
  _StopButtonState createState() => _StopButtonState();
}

class _StopButtonState extends State<StopButton> {
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
            "Stop",
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
              "Stop",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: stopSession,
          ),
        ),
      ),
    );
  }

  Future stopSession() async {
    //Send data to db//
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    id = localStorage.getString('userKey');
    barcode = localStorage.getString('barcodeKey');

    var data = {
      'id': id,
      'barcode': barcode,
    };

    //Post Start Session data to db via API//
    var response = await CallAPi().postData(data, 'stop');
    var body = json.decode(response.body);
    print(body);
    if (body == 'success') {
      //Navigate the start page//
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Start(),
        ),
      );
      //Confirmation message//
      Flushbar(
        message: 'Session terminated successfully!',
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
        message: 'Session did not terminate!',
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
