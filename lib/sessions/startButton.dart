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

  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Start Button",
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Center(
                    child: Text("Click start button to begin session",
                        style: style.copyWith(
                          color: Color(0xff01A0C7),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: FloatingActionButton.extended(
                      backgroundColor: Color(0xff01A0C7),
                      elevation: 0.0,
                      label: Text(
                        _isLoading ? 'Starting...' : 'Start',
                        style: style.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onPressed: startSession,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*Handles session initialization */
  Future startSession() async {
    setState(() {
      _isLoading = true;
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
    print(body);

    if (body == 'asset does not exist') {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('barcodeKey');

      /* Error message */
      Flushbar(
        message: 'Asset does not exist. Please choose a valid asset in record!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 8),
        backgroundColor: Colors.redAccent,
      )..show(context);
    } else if (body == 'asset not signed off') {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('barcodeKey');

      /* Error message */
      Flushbar(
        message: 'Asset has not been signed out. Please contact lab admin!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 8),
        backgroundColor: Colors.redAccent,
      )..show(context);
    } else {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Stop(),
        ),
      );

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('barcodeKey');

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
    }
  }
}
