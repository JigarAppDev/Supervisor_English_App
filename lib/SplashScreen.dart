import 'dart:async';
import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Utils/Constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    getUserToken();
    startTime();
  }

  var user_token;
  var user_type;
  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    user_type = await getPrefData(key: 'user_type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(color: Colors.white),
    );
  }

  Future startTime() async {
    var duration = new Duration(microseconds: 1);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => user_token == null || user_token == 'null' || user_token == '' ? LoginScreen() : HomeScreen()), (route) => false);
  }
}
