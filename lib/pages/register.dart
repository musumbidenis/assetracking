import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';

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
                    style: TextStyle(fontSize: 16.0),
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
                      left: 25.0, right: 25.0, top: 50.0, bottom: 15.0),
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
                                    _isLoading ? 'REGISTERING...' : 'REGISTER',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Source Sans Pro',
                                        letterSpacing: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            onTap: _handleRegister,
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

      var connectionStatus =
          (await Connectivity().checkConnectivity()).toString();

      /*User data to be submitted */
      var data = {
        'id': userId.text,
        'fname': firstName.text,
        'surname': surname.text,
        'email': email.text,
        'phoneNumber': phone.text,
        'idNumber': idNumber.text,
      };

      if (connectionStatus == "ConnectivityResult.none") {
        setState(() {
          _isLoading = false;
        });
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

      /*Handles posting user data */
      var response = await CallAPi().postData(data, 'register');
      var body = json.decode(response.body);
      if (body == 'success') {
        Navigator.pop(context);

        /*Success message */
        Flushbar(
          message: 'Registration was successfull!',
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
        userId.clear();
        firstName.clear();
        surname.clear();
        idNumber.clear();
        phone.clear();
        email.clear();

        setState(() {
          _isLoading = false;
        });
      } else {
        /**Set loading state of button to false &&
         * Clear the text fields
        */
        userId.clear();
        firstName.clear();
        surname.clear();
        idNumber.clear();
        phone.clear();
        email.clear();

        setState(() {
          _isLoading = false;
        });

        /*Error message */
        Flushbar(
          message: 'Admission No or Employee Id entered is already registered!',
          icon: Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.white,
          ),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        )..show(context);
      }
    }
  }
}
