import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:assetracking/widgets/widgets.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey();

  /*Text Controllers */
  TextEditingController userId = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController idNumber = TextEditingController();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Column(
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff01A0C7)),
                ),
                Text(
                  "Create a new account",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 50.0, bottom: 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userId,
                          decoration: InputDecoration(
                            labelText: "Admission Number Or Employee ID",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
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
                          controller: firstName,
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
                          ),
                          cursorColor: Color(0xff01A0C7),
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "First Name field cannot be blank";
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: surname,
                          decoration: InputDecoration(
                            labelText: "Surname",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
                          ),
                          cursorColor: Color(0xff01A0C7),
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Surname field cannot be blank";
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: idNumber,
                          decoration: InputDecoration(
                            labelText: "ID Number",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
                          ),
                          cursorColor: Color(0xff01A0C7),
                          keyboardType: TextInputType.phone,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "ID Number field cannot be blank";
                            } else if (value.length < 8 || value.length > 8) {
                              return "ID Number cannot be less than or greater than eight";
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
                          ),
                          cursorColor: Color(0xff01A0C7),
                          keyboardType: TextInputType.phone,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Phone field cannot be blank";
                            } else if (value.length < 10 || value.length > 10) {
                              return "Phone field cannot be less than or greater than ten";
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              color: Colors.grey[400],
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff01A0C7))),
                          ),
                          cursorColor: Color(0xff01A0C7),
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Email field cannot be blank";
                            } else if (!value.contains("@")) {
                              return "Please enter a valid email";
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
                                          'REGISTER',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontFamily: 'Source Sans Pro',
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2.0),
                                        ),
                                ),
                              ),
                            ),
                            onTap: _isLoading ? null : _handleRegister,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xff01A0C7),
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

/*Handles Form submission */
  void _handleRegister() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      var data = {
        'id': userId.text,
        'fname': firstName.text,
        'surname': surname.text,
        'email': email.text,
        'phoneNumber': phone.text,
        'idNumber': idNumber.text,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        var response = await CallAPi().postData(data, 'register');
        var body = json.decode(response.body);
        if (body == 'success') {
          setState(() {
            _isLoading = false;
          });

          userId.clear();
          firstName.clear();
          surname.clear();
          idNumber.clear();
          phone.clear();
          email.clear();

          Navigator.pop(context);

          alert('Registeration was successfull', Colors.green, context);
        } else {
          setState(() {
            _isLoading = false;
          });

          userId.clear();

          alert('Admission No or Employee Id entered is already registered',
              Colors.red, context);
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
