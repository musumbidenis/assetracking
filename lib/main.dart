import 'package:assetracking/pages/login.dart';
import 'package:assetracking/sessions/start.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;


  @override
  void initState(){
    _checkIfLoggedIn();
    super.initState();
  }
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isLoggedIn ? Start() : Login(),
    );
  }
  //Check if user is logged in//
  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('userKey');

    //If !=null remain logged in//
    if(user!=null){
      _isLoggedIn = true;
    }
  }
}
