import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/login.dart';
import 'package:assetracking/sessions/startButton.dart';
import 'package:assetracking/sessions/stop.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  ///Styling for texts///
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  ///Initialize the variables///
  String barcode = "";
  String id;
  String _lab;

  List labs = List();

  @override
  void initState() {
    super.initState();
    this.getLabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () => _onExitApp(context),
                ),
              ),
            ]),
        body: Center(
          child: SingleChildScrollView(
            child: startScreen(),
          ),
        ));
  }

////////////Start Screen Widget/////////////
  Widget startScreen() {
    return Container(
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

          SizedBox(height: 28.0),

          ///Dropdown button for labs///
          Center(
            child: Container(
              child: DropdownButton(
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 50,
                underline: Container(
                  height: 3.0,
                  color: Color(0xff01A0C7),
                ),
                elevation: 10,
                hint: Text(
                  "Select Computer Lab",
                  style: style,
                ),
                items: labs.map((item) {
                  return DropdownMenuItem(
                    value: item['labId'],
                    child: Text(
                      item['description'],
                      style: style,
                    ),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _lab = newVal;
                  });
                },
                value: _lab,
              ),
            ),
          ),

          SizedBox(height: 35.0),

          /////Scan button/////
          Center(
            child: Container(
              width: 250.0,
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

          SizedBox(height: 8.0),

          /////Already in session ---> Stop()/////
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
                      context, MaterialPageRoute(builder: (context) => Stop()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  ////////////getLabs API////////////
  void getLabs() async {
    var response = await CallAPi().getData('getLabs');
    var body = json.decode(response.body);
    setState(() {
      labs = body;
    });
  }

//////////Scanning QrCode operation///////////
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      //Assign the scanned value to a variable//
      setState(() async {
        this.barcode = barcode;

        //Store the value to localstorage//
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('barcodeKey', barcode);
        localStorage.setString('labKey', _lab);

        //Navigate to the start button//
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartButton()),
        );

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

  ///////Handles the exit alert dialog//////
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
            onPressed: () async {
              //Navigate to the login page//
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );

              //Remove user from localstorage//
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              localStorage.remove('userKey');
            },
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
        ]);
  }
}
