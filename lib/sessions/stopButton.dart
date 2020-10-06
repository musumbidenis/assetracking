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
  bool _isLoading = false;

  String id;
  String barcode;
  String lab;

  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        title: Text(
          "Stop Button",
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
                    child: Text("Click stop button to terminate session",
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
                        "Start",
                        style: style.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onPressed: stopSession,
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

/*Handles termination of a session */
  Future stopSession() async {
    setState(() {
      _isLoading = true;
    });

    /*Gets data from local storage */
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    id = localStorage.getString('userKey');
    barcode = localStorage.getString('barcodeKey');

    var data = {
      'id': id,
      'barcode': barcode,
    };

    /*Sends data to database */
    var response = await CallAPi().postData(data, 'stop');
    var body = json.decode(response.body);
    if (body == 'success') {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Start(),
        ),
      );

      /*Remove asset from localstorage */
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('barcodeKey');

      /*Success message */
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
      setState(() {
        _isLoading = false;
      });

      /*Error message */
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
