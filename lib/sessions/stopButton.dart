import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
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
                          _isLoading ? 'Stopping...' : 'Stop',
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
      ),
    );
  }

/*Handles termination of a session */
  Future stopSession() async {
    var connectionStatus =
        (await Connectivity().checkConnectivity()).toString();

    if (connectionStatus == "ConnectivityResult.none") {
      setState(() {
        _isLoading = false;
      });
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return PlatformAlertDialog(
                title: Center(child: Text('')),
                content: SingleChildScrollView(
                  child: Text(
                      "No Internet Connection available 😟 Please check your internet connection and try again.",
                      style: TextStyle(fontSize: 16.0)),
                ),
                actions: <Widget>[
                  PlatformDialogAction(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
    } else {
      /*Sets button's loading state*/
      setState(() {
        _isLoading = true;
      });
    }

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
            'Youve not signed in for this asset. Please scan the correct asset!',
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
    }
  }
}
