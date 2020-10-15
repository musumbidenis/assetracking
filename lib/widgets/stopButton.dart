import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:assetracking/widgets/widgets.dart';
import 'package:assetracking/screens/screens.dart';
import 'package:flutter_offline/flutter_offline.dart';
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
                    style: TextStyle(fontSize: 17.0),
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
                        label: _isLoading
                            ? SizedBox(
                                height: 28.0,
                                width: 28.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black12),
                                ),
                              )
                            : Text(
                                'Stop',
                                style:
                                    style.copyWith(fontWeight: FontWeight.bold),
                              ),
                        onPressed: _isLoading ? null : stopSession,
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

/*Handles termination of a session */
  Future stopSession() async {
    /*Sets button's loading state*/
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

    try {
      /*Sends data to database */
      var response = await CallAPi().postData(data, 'stop');
      var body = json.decode(response.body);

      if (body == 'youre not signed in for this asset') {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();

        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('barcodeKey');

        /* Error message */
        Flushbar(
          message:
              'You\'ve not signed in for this asset. Please scan the correct asset',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 8),
          backgroundColor: Colors.red,
        )..show(context);
      } else {
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
          message: 'Session terminated successfully',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        )..show(context);
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });
      /*Error message */
      Flushbar(
        message:
            'Request took too long to respond. Check your internet connection and try again',
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
