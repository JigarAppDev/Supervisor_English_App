import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor_english_app/SplashScreen.dart';
import 'Utils/Constants.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supervisor English App',
      theme: ThemeData(primaryColor: kPrimaryColor),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
