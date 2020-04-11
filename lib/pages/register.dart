import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey();

  ///Styling for texts///
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

  ///Text Controllers///
  TextEditingController userIdController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Registration",
            style: style.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: registerForm(),
            ),
          ),
        ),
      ),
    );
  }

///////////Registration Form Widget/////////////
  Widget registerForm() {
    return Column(
      children: <Widget>[
        /////User id text field/////
        TextFormField(
          controller: userIdController,
          obscureText: false,
          style: style.copyWith(fontSize: 18),
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.isEmpty) {
              return "User id is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Adm No. or Employee Id",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 15.0),

        /////First Name text field/////
        TextFormField(
          controller: fnameController,
          obscureText: false,
          style: style,
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.isEmpty) {
              return "First name is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "first name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 15.0),

        /////Surname text field/////
        TextFormField(
          controller: surnameController,
          obscureText: false,
          style: style,
          keyboardType: TextInputType.text,
          validator: (String value) {
            if (value.isEmpty) {
              return "Surname is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "surname",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 15.0),

        /////Email text field/////
        TextFormField(
          controller: emailController,
          obscureText: false,
          style: style,
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty) {
              return "email address is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "email address",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 15.0),

        /////Phone Number text field/////
        TextFormField(
          controller: phoneController,
          obscureText: false,
          style: style,
          keyboardType: TextInputType.number,
          validator: (String value) {
            if (value.isEmpty) {
              return "phone number is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "phone number",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 15.0),

        /////Id Number text field/////
        TextFormField(
          controller: idController,
          obscureText: false,
          style: style,
          keyboardType: TextInputType.number,
          validator: (String value) {
            if (value.isEmpty) {
              return "id number is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "id number",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 25.0),

        /////Registration button/////
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: _handleRegister,
            child: Text(_isLoading ? 'Registering...' : "Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),

        SizedBox(height: 15.0),

        /////Already have an account ---> Login()/////
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Already have an account?",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff01A0C7),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

////////////Handling user registration///////////
  void _handleRegister() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      //User data to be pushed to db//
      var data = {
        'id': userIdController.text,
        'fname': fnameController.text,
        'surname': surnameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'idNumber': idController.text,
      };

      //Set the registration button to loading state//
      setState(() {
        _isLoading = true;
      });

      //Handles posting user data via API//
      var response = await CallAPi().postData(data, 'register');
      var body = json.decode(response.body);
      if (body == 'success') {
        //Navigate to login page
        Navigator.pop(context);

        //Confirmation message//
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

        //Set loading state of button to false//
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
