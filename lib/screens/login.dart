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
                      style: TextStyle(fontSize: 19.0),
                    ),
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
                    left: 25.0, right: 25.0, top: 50.0, bottom: 8.0),
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
                          } else if (value.length < 8) {
                            return "ID Number must be atleast eight characters";
                          }
                        },
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        height: 50.0,
                        child: GestureDetector(
                          child: Material(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xff01A0C7),
                            elevation: 5.0,
                            child: GestureDetector(
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        height: 28.0,
                                        width: 28.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black12),
                                        ),
                                      )
                                    : Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontFamily: 'Source Sans Pro',
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0),
                                      ),
                              ),
                            ),
                          ),
                          onTap: _isLoading ? null : _handleLogin,
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

      var data = {
        'id': userIdController.text,
        'idNumber': idController.text,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await CallAPi().postData(data, 'login');
        var body = json.decode(response.body);
        if (body == 'success') {
          setState(() {
            _isLoading = false;
          });

          userIdController.clear();
          idController.clear();

          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          await localStorage.setString('userKey', userIdController.text);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Start()),
          );

          alert('Login was successfull', Colors.green, context);
        } else {
          setState(() {
            _isLoading = false;
          });

          idController.clear();

          alert(
              'Incorrect login details. Please try again', Colors.red, context);
        }
      } on TimeoutException {
        setState(() {
          _isLoading = false;
        });

        alert(
            'Request took too long to respond. Check your internet connection and try again',
            Colors.red,
            context);
      } on SocketException {
        setState(() {
          _isLoading = false;
        });

        alert(
            'Network is unreachable. Check your internet connection and try again',
            Colors.red,
            context);
      }
    }
  }
}
