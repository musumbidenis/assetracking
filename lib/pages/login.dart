import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/register.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:flutter_offline/flutter_offline.dart';
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Oops,',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Text(
                    "No internet connection",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Check your connection and try again",
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            );
          }
          return child;
        },
        child: SingleChildScrollView(
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
                                  _isLoading ? 'LOGING..' : 'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Source Sans Pro'),
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
                          color: Color(0xff01A0C7),
                          fontWeight: FontWeight.bold),
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
      ),
    );
  }

/*Handles form submission */
  void _handleLogin() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      /*Data to be cross-checked in the db */
      var data = {
        'id': userIdController.text,
        'idNumber': idController.text,
      };

      /*Sets button's loading state*/
      setState(() {
        _isLoading = true;
      });

      try {
        /*verify login credentials provided */
        var response = await CallAPi().postData(data, 'login');
        var body = json.decode(response.body);
        if (body == 'success') {
          /*Save students admission in the localStorage */
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          await localStorage.setString('userKey', userIdController.text);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Start()),
          );

          /*Success message */
          Flushbar(
            message: 'Login was successfull',
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

          setState(() {
            _isLoading = false;
          });

          /*Error message */
          Flushbar(
            message: 'Incorrect login details. Please try again',
            icon: Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.white,
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.redAccent,
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
}
