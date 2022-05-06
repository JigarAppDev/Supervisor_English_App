import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Screens/HomeScreen.dart';
import 'package:supervisor_english_app/Screens/ManageProject/AllFormScreen.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isChecked = true;
  late String deviceToken;
  late int deviceType;
  var deviceID;

  Future<void> getDeviceTypeId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceType = 1;
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.androidId;
    } else {
      deviceType = 2;
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor;
    }
  }

  getDeviceToken() {
    var random = Random();
    var values = List<int>.generate(200, (i) => random.nextInt(255));
    deviceToken = base64UrlEncode(values);
    print('Device Token: ' + deviceToken);
  }

  @override
  void initState() {
    getDeviceTypeId();
    getDeviceToken();
    super.initState();
  }

  late Response response;
  Dio dio = Dio();
  var jsonData;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        LOGIN,
        data: {
          'email_id': email.text,
          'password': password.text,
          'device_id': deviceID,
          'device_token': deviceToken,
          'device_type': deviceType,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
          print(jsonData);
        });
        if (jsonData['Status'] == 1) {
          await setUserData();
          setState(() {
            isLoading = false;
            print('Bhautik Log --> ${jsonData['info']['user_type']}');
            if (jsonData['info']['user_type'] == 0) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AllFormScreen()), (route) => false);
            } else if (jsonData['info']['user_type'] == 1) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
            }
            Toasty.showtoast(jsonData['Message']);
          });
        }
        if (jsonData['Status'] == 0) {
          setState(() {
            isLoading = false;
          });
          Toasty.showtoast(jsonData['Message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  Future setUserData() async {
    await setPrefData(key: 'device_id', value: jsonData['info']['device_id'].toString());
    await setPrefData(key: 'UserToken', value: jsonData['UserToken'].toString());
    await setPrefData(key: 'email_id', value: jsonData['info']['email_id'].toString());
    await setPrefData(key: 'user_type', value: jsonData['info']['user_type'].toString());
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double mWidth = MediaQuery.of(context).size.width;
    final double mHeight = MediaQuery.of(context).size.height;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xff365A0C);
      }
      return Color(0xff365A0C);
    }

    return Container(
      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/BG.png'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0,
          progressIndicator: Container(
            height: 50,
            width: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              colors: const [kPrimaryColor],
              strokeWidth: 2,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: mHeight * 0.40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            // fit: BoxFit.cover,
                            image: AssetImage('$ICON_URL/header.png'))),
                  ),
                  SizedBox(height: 10),
                  AppText(
                    text: 'Login',
                    color: Color(0xff707070),
                    fontFamily: 'nunito-sans-extrabold',
                    fontSize: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AppText(
                            text: 'Email',
                            fontSize: 12,
                            color: Color(0xff707070),
                            fontFamily: 'nunito-sans-semibold',
                          ),
                        ),
                        Container(
                          height: 45,
                          width: mWidth,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Color(0xff707070))),
                          child: TextField(
                            controller: email,
                            cursorColor: Colors.black38,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontFamily: 'nunito-sans-semibold',
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AppText(
                            text: 'Password',
                            fontSize: 12,
                            color: Color(0xff707070),
                            fontFamily: 'nunito-sans-semibold',
                          ),
                        ),
                        Container(
                          height: 45,
                          width: mWidth,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Color(0xff707070))),
                          child: TextField(
                            controller: password,
                            cursorColor: Colors.black38,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontFamily: 'nunito-sans-semibold',
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AppText(
                                text: 'Remind me',
                                fontSize: 12,
                                color: Color(0xff707070),
                                fontFamily: 'nunito-sans-semibold',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    fontFamily: 'nunito-sans-extrabold',
                    width: mWidth * 0.75,
                    height: 45,
                    onPressed: () {
                      if (_userValidate(email: email.text, password: password.text)) {
                        loginUser();
                      }
                    },
                    borderRadius: 30,
                    backgroundcolor: Color(0xffAEA2C7),
                    title: 'LOGIN',
                    fontSize: 13,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _userValidate({required String email, required String password}) {
    if (email.isEmpty && password.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (email.isEmpty) {
      Toasty.showtoast('Please Enter Your Email Address');
      return false;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toasty.showtoast('Please Enter Valid Email Address');
      return false;
    } else if (password.isEmpty) {
      Toasty.showtoast('Please Enter Your Password');
      return false;
    } else if (password.length < 6) {
      Toasty.showtoast('Password Must Contains 6 Characters');
      return false;
    } else {
      return true;
    }
  }
}
