import 'package:assetracking/pages/login.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:assetracking/sessions/stopButton.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stop extends StatefulWidget {
  @override
  _StopState createState() => _StopState();
}

class _StopState extends State<Stop> {
  ///Styling for texts///
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              "Stop Session",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30.0,
                  ),
                  onPressed: () => _onExitApp(context),
                ),
              ),
            ]),
        body: Center(
          child: SingleChildScrollView(
            child: stopScreen(),
          ),
        ));
  }

////////////Dropdown button for choosing courses/////////////
  Widget stopScreen() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Center(
              child: Text("Stop current laboratory session",
                  style: style.copyWith(
                    color: Color(0xff01A0C7),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),

          SizedBox(height: 35.0),

          /////Start button/////
          Center(
            child: Container(
              width: 250,
              height: 50.0,
              child: FloatingActionButton.extended(
                elevation: 0.0,
                icon: Icon(
                  Icons.camera_alt,
                  size: 30.0,
                ),
                label: Text(
                  "Scan",
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: scan,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var barcode2 = localStorage.getString('barcodeKey');

      if (barcode2 == barcode) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StopButton()),
        );
      } else {
        Flushbar(
          message: 'Scanned wrong asset!',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )..show(context);
      }
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Start()),
      );
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

  _onExitApp(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure you want to quit application?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          ),
          color: Color(0xff01A0C7),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.redAccent,
        )
      ],
    ).show();
  }
}
