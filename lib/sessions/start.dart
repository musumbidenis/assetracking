import 'package:assetracking/sessions/startButton.dart';
import 'package:assetracking/sessions/stop.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool _isVisible = true;

  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  String barcode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xff01A0C7),
            title: Text(
              "Start Session",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: alert,
                ),
              ),
            ]),
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
                      child: Text("Start a new laboratory session",
                          style: style.copyWith(
                            color: Color(0xff01A0C7),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // FloatingActionButton.extended(
                  //   backgroundColor: Color(0xff01A0C7),
                  //   elevation: 0.0,
                  //   label: Text(
                  //     "HIDE",
                  //     style: style.copyWith(fontWeight: FontWeight.bold),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isVisible = !_isVisible;
                  //     });
                  //   },
                  // ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Visibility(
                        visible: _isVisible,
                        child: FloatingActionButton.extended(
                          backgroundColor: Color(0xff01A0C7),
                          elevation: 0.0,
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30.0,
                          ),
                          label: Text(
                            "Scan",
                            style: style.copyWith(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                            scan();
                          },
                        ),
                        // replacement: FloatingActionButton.extended(
                        //   backgroundColor: Color(0xff01A0C7),
                        //   elevation: 0.0,
                        //   icon: Icon(
                        //     Icons.straighten,
                        //     size: 30.0,
                        //   ),
                        //   label: Text(
                        //     "Start",
                        //     style: style.copyWith(fontWeight: FontWeight.bold),
                        //   ),
                        //   onPressed: null,
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already in a laboratory session?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        child: Text(
                          "Stop",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff01A0C7),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StartButton()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

/*Handles scanning of an asset */
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      setState(() async {
        this.barcode = barcode;

        /*Store the value to localstorage */
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('barcodeKey', barcode);

        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Flushbar(
          message: 'Camera access denied',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      } else {
        Flushbar(
          message: 'Unkown error, please try again',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      }
    } on FormatException {
      Flushbar(
        message:
            'User returned using the "back"-button before scanning anything',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);

      setState(() {
        _isVisible = _isVisible;
      });
    } catch (e) {
      Flushbar(
        message: 'Unkown error, please try again',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }

  /* Handles the exit alert dialog */
  void alert() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
              title: Center(child: Text('Exit Application')),
              content: SingleChildScrollView(
                child: Text("Are you sure you want to exit app ? ",
                    style: TextStyle(fontSize: 17.0)),
              ),
              actions: <Widget>[
                PlatformDialogAction(child: Text('YES'), onPressed: () {}),
                PlatformDialogAction(
                    child: Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
