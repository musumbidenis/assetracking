import 'package:assetracking/sessions/start.dart';
import 'package:assetracking/sessions/stopButton.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stop extends StatefulWidget {
  @override
  _StopState createState() => _StopState();
}

class _StopState extends State<Stop> {
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff01A0C7),
          title: Text(
            "Stop Session",
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
                      child: Text("Stop current laboratory session",
                          style: style.copyWith(
                            color: Color(0xff01A0C7),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(height: 35.0),
                  Center(
                    child: Container(
                      width: 250,
                      height: 50.0,
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
                        onPressed: scan,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });

      /*Sets the asset code stored in localstorage */
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('barcodeKey', barcode);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StopButton()),
      );
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
        message: 'You returned back before scanning anything',
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
}
