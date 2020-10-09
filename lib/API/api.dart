import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

class CallAPi {
  final String _url = 'https://assetracking.musumbidenis.co.ke/api/';

  /*Posts data to database */
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  /*Fetches data from database */
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}

/*Checks if user has internet connection */
checkConnectivity(context, status) async {
  String connectionStatus;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = new Connectivity();
  try {
    connectionStatus = (await _connectivity.checkConnectivity()).toString();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatus = result.toString();
      // print(connectionStatus);
    });
  } on PlatformException catch (e) {
    // print(e.toString());
    connectionStatus = 'Failed to get connectivity.';
  }
  if (connectionStatus == "ConnectivityResult.none") {
    status = 'null';
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
  }
}
