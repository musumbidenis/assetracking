import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/register.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:connectivity/connectivity.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey();

  /*Text Controllers */
  TextEditingController userIdController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff01A0C7)),
              ),
            ),
            Text(
              "Sign in to continue",
              style: TextStyle(color: Colors.grey[700]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 50.0, bottom: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        labelText: "Admission Number Or Employee ID",
                        labelStyle: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          color: Colors.grey[400],
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff01A0C7),
                        )),
                      ),
                      cursorColor: Color(0xff01A0C7),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be blank";
                        }
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: "ID Number",
                        labelStyle: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          color: Colors.grey[400],
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff01A0C7),
                        )),
                      ),
                      cursorColor: Color(0xff01A0C7),
                      keyboardType: TextInputType.phone,
                      obscureText: true,
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "ID Number field cannot be blank";
                        } else if (value.length < 8 || value.length > 8) {
                          return "ID Number cannot be less than or greater than eight";
                        }
                      },
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          shadowColor: Colors.blue,
                          color: Color(0xff01A0C7),
                          elevation: 5.0,
                          child: GestureDetector(
                            child: Center(
                              child: Text(
                                _isLoading ? 'LOGING...' : 'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Source Sans Pro',
                                    letterSpacing: 2.0),
                              ),
                            ),
                          ),
                        ),
                        onTap: _handleLogin,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don\'t have an account? "),
                GestureDetector(
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Color(0xff01A0C7), fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

/*Handles form submission */
  void _handleLogin() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      var connectionStatus =
          (await Connectivity().checkConnectivity()).toString();

      /*Data to be cross-checked in the db */
      var data = {
        'id': userIdController.text,
        'idNumber': idController.text,
      };

      if (connectionStatus == "ConnectivityResult.none") {
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

      /*verify login credentials provided */
      var response = await CallAPi().postData(data, 'login');
      var body = json.decode(response.body);
      if (body == 'success') {
        /*Save students admission in the localStorage */
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        await localStorage.setString('userKey', userIdController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Start()),
        );

        /*Success message */
        Flushbar(
          message: 'Login successfull!',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        )..show(context);

        /**Set loading state of button to false &&
         * Clear the text fields
        */
        userIdController.clear();
        idController.clear();

        setState(() {
          _isLoading = false;
        });
      } else {
        /**Set loading state of button to false &&
         * Clear the text fields
        */
        userIdController.clear();
        idController.clear();

        setState(() {
          _isLoading = false;
        });

        /*Error message */
        Flushbar(
          message: 'Incorrect details!',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.redAccent,
        )..show(context);
      }
    }
  }
}
