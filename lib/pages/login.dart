import 'dart:convert';
import 'package:assetracking/API/api.dart';
import 'package:assetracking/pages/register.dart';
import 'package:assetracking/sessions/start.dart';
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

//Styling for texts//
  TextStyle style = TextStyle(fontFamily: "Montserrat", fontSize: 20.0);

//Text Controllers//
  TextEditingController userIdController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text("Login", style: style.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 0, 36, 0),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: loginForm(),
            )),
          ),
        ),
      ),
    );
  }

////////////Login Form Widget////////////
  Widget loginForm() {
    return Column(
      children: <Widget>[
        /////User id Number text field/////
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

        /////Id Number text field/////
        TextFormField(
          controller: idController,
          obscureText: true,
          style: style,
          validator: (String value) {
            if (value.isEmpty) {
              return "Id number required";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "id number",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),

        SizedBox(height: 25.0),

        /////Login button/////
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: _handleLogin,
            child: Text(_isLoading ? "Loging..." : "Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),

        SizedBox(height: 15.0),

        /////Don't have an account ---> Register()/////
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dont have an account?",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              child: Text(
                "Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff01A0C7),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
            ),
          ],
        ),
      ],
    );
  }

////////////Handling login authetication/////////////
  void _handleLogin() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    }

    //Data to be cross-checked in the db//
    var data = {
      'id': userIdController.text,
      'idNumber': idController.text,
    };

    //Set the login button to loading state//
    setState(() {
      _isLoading = true;
    });

    //Cross-check data in the db via API//
    var response = await CallAPi().postData(data, 'login');
    var body = json.decode(response.body);
    if (body == 'success') {
      //Save student admission in the localStorage//
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setString('userKey', userIdController.text);
      //Navigate to the homepage//
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Start()),
      );

      //Redirect with success message//
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

      //Set loading state of button to false//
      setState(() {
        _isLoading = false;
      });

    } else {
      //Navigate to the login page//
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );


      //Redirect with error message//
      Flushbar(
        message: 'Incorrect details!',
        icon: Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.white,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      )..show(context);
    }
  }
}
