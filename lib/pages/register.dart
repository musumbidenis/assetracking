import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/login.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
                        keyboardType: TextInputType.number,
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "ID Number field cannot be blank";
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
                        keyboardType: TextInputType.phone,
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Phone field cannot be blank";
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
                              borderSide: BorderSide(color: Color(0xff01A0C7))),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Email field cannot be blank";
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
                                  _isLoading ? 'REGISTERING..' : 'REGISTER',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Source Sans Pro'),
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
                  InkWell(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xff01A0C7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
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

/*Handles Form submission */
  void _handleRegister() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      /*User data to be submitted */
      var data = {
        'id': userId.text,
        'fname': firstName.text,
        'surname': surname.text,
        'email': email.text,
        'phoneNumber': phone.text,
        'idNumber': idNumber.text,
      };

      /*Set the registration button to loading state */
      setState(() {
        _isLoading = true;
      });

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
