import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Screens/BottombarScreen.dart';
import 'package:supervisor_english_app/Screens/LoginScreen.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';
import 'CustomWidget.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Response response;
  Dio dio = Dio();
  var jsonData;
  void logoutUser() async {
    try {
      response = await dio.post(
        LOGOUT,
        data: {
          'device_id': device_id,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $user_token'
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['Status'] == 1) {
          clearPrefData();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          Toasty.showtoast(jsonData['Message']);
        }
        if (jsonData['Status'] == 0) {
          Toasty.showtoast(jsonData['Message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var device_id;
  Future getDeviceId() async {
    device_id = await getPrefData(key: 'device_id');
    user_token = await getPrefData(key: 'UserToken');
  }

  var user_token;

  @override
  void initState() {
    // TODO: implement initState
    getDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Color(0xffCECECE),
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(
                  fontFamily: 'nunito-sans-semibold',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottombarScreen()));
                  },
                  borderRadius: 10,
                  backgroundcolor: Color(0xffE65B37),
                  title: 'ANALYSIS OF DATA',
                  textColor: Colors.white,
                  fontSize: 13,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: GestureDetector(
                  onTap: () {
                    logoutDialog(context);
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        // color: Colors.white60,
                        border: Border.all(color: Color(0xffE65B37)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: AppText(
                        text: 'SIGN OFF',
                        color: Color(0xffE65B37),
                        fontFamily: 'nunito-sans-EXTRABOLD',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logoutDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.black)),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Logout", style: TextStyle(color: Colors.black)),
      onPressed: logoutUser,
    );
    AlertDialog alert = AlertDialog(
      titleTextStyle: khintTextStyle1,
      title: Text("Logout"),
      content: Text("Are you sure you want to Logout?", style: khintTextStyle),
      actions: [cancelButton, continueButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
