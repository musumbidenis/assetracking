import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

alert(String message, Color backgroundColor, context) {
  Flushbar(
    message: message,
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: Colors.white,
    ),
    duration: Duration(seconds: 8),
    backgroundColor: backgroundColor,
  )..show(context);
}

/* Handles the exit alert dialog */
exitAlert(context) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
            title: Text('Exit Application?'),
            content: SingleChildScrollView(
              child: Text("This action cannot be undone.",
                  style: TextStyle(fontSize: 18.0)),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                  child: Text('YES'),
                  onPressed: () async {
                    /*Store the value to localstorage */
                    SharedPreferences localStorage =
                        await SharedPreferences.getInstance();
                    localStorage.clear();

                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }),
              PlatformDialogAction(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      });
}
