import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:assetracking/API/api.dart';
import 'package:assetracking/sessions/stop.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
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
      body: OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.portable_wifi_off,
                    size: 80.0,
                    color: Color(0xff01A0C7),
                  ),
                  Text(
                    'Oops,',
                    style: TextStyle(fontSize: 19.0),
                  ),
                  Text(
                    "No internet connection",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Text(
                    "Check your connection and try again",
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
            );
          }
          return child;
        },
        child: Center(
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
      ),
    );
  }

/*Handles session initialization */
  Future startSession() async {
    /*Sets button's loading state*/
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
    try {
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
          message:
              'Asset does not exist. Please choose a valid asset in record!',
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
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });
      /*Error message */
      Flushbar(
        message:
            'Request took long to respond. Check your internet connection and try again',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 12),
        backgroundColor: Colors.red,
      )..show(context);
    } on SocketException {
      setState(() {
        _isLoading = false;
      });
      /*Error message */
      Flushbar(
        message:
            'Network is unreachable. Check your internet connection and try again',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 12),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }
}
