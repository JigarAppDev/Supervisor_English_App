import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Screens/ManageProject/AllFormScreen.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

import 'CreateNewUser.dart';

class NewUserMain extends StatefulWidget {
  @override
  _NewUserMainState createState() => _NewUserMainState();
}

class _NewUserMainState extends State<NewUserMain> {
  FutureOr onGoBack(dynamic value) {
    getUserList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserToken();

    super.initState();
  }

  var user_token;
  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    print('user_tokenform');
    print(user_token);
    await getUserList();
  }

  late Response response;
  Dio dio = Dio();
  bool isLoading = false;
  var jsonData;
  List userList = [];
  Future getUserList() async {
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        LIST_USER,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $user_token'
          },
        ),
      );
      print('response');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
            userList = jsonData['data'];
            print('userList');
            print(userList);
            // Toasty.showtoast(jsonData['msg']);
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Toasty.showtoast(jsonData['msg']);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Toasty.showtoast(jsonData['msg']);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception Detected >>> ${e.toString()} <<<');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mWidth = MediaQuery.of(context).size.width;
    final double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Supervisor',
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'nunito-sans-extrabold',
              color: Color(0xff212529),
              fontWeight: FontWeight.w700),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('$ICON_URL/Group 73619.png',
                  height: 20, width: 20)),
        ),
      ),
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/icons/BG.png'))),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: mWidth,
                      decoration: BoxDecoration(
                          color: Color(0xff5B4293),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Create new User',
                              color: Colors.white,
                              fontFamily: 'nunito-sans-extrabold',
                              fontSize: 20,
                            ),
                            SizedBox(height: 10),
                            AppText(
                              text:
                                  'You can create and assign user to your different project and/or forms',
                              color: Color(0xffB684FF),
                              fontFamily: 'nunito-sans-regular',
                              fontSize: 15,
                            ),
                            SizedBox(height: 15),
                            CustomButton(
                              fontFamily: 'nunito-sans-semibold',
                              width: mWidth,
                              height: 50,
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateNewUserScreen()))
                                    .then((onGoBack));
                              },
                              borderRadius: 10,
                              backgroundcolor: Color(0xff442E7A),
                              title: 'Create User',
                              textColor: Colors.white,
                              fontSize: 15,
                              icon: 'Button.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              print('tap');
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllFormScreen(
                                            userId: userList[index]
                                                ['user_id'])));
                              });
                            },
                            child: Container(
                              width: mWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE65B37),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        AppText(
                                          text: userList[index]['username'],
                                          fontFamily: 'nunito-sans-semibold',
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
