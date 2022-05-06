import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class CreateNewUserScreen extends StatefulWidget {
  @override
  _CreateNewUserScreenState createState() => _CreateNewUserScreenState();
}

class _CreateNewUserScreenState extends State<CreateNewUserScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController phone = TextEditingController();

  var _dropdownValues;

  var userTypeList = [
    'Collaborator',
    'Reader',
  ];

  List ProjectList = [];
  List formList = [];
  List selectedformindex = [];
  var isShow = false;
  var isShowForm = false;
  late Response response;
  Dio dio = Dio();
  var userType;
  var role_id;
  bool isLoading = false;
  List formProjectId = [];


  void CreateUser() async {
    setState(() {
      isLoading = true;
    });
    var jsonData;
    try {
      response = await dio.post(
        'http://54.165.154.132:4000/users/add_user',
        data: {
          'username': userName.text,
          'email_id': email.text,
          'password': password.text,
          'user_type': userType,
          'role_id': role_id,
          'phone_number': phone.text,
          'project_id': projectIdList.join(','),
          'form_id': formIdList.join(','),
          'form_project_id': formProjectId.join(','),
        },
        options: Options(
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $user_token'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
            Toasty.showtoast(jsonData['msg']);
            Navigator.pop(context);
          });
        }
        if (jsonData['success'] == 0) {
          setState(() {
            isLoading = false;
          });
          Toasty.showtoast(jsonData['msg']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });

    }
  }

  void projectWiseFormList({var projectId}) async {
    var jsonData;
    try {
      response = await dio.post(
        LIST_PROJECT_BY_USER,
        data: {
          'project_id': projectId,
        },
        options: Options(
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $user_token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
          print(jsonData);
        });
        if (jsonData['success'] == 1) {
          setState(() {
            formList = jsonData['data'];
          });
        }
        if (jsonData['success'] == 0) {
          Toasty.showtoast(jsonData['msg']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response);
      print(e.toString());
    }
  }

  var user_token;
  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    print('user_token');
    print(user_token);
    await getUserProjectList();
  }

  @override
  void initState() {

    getUserToken();
    super.initState();
  }

  Future getUserProjectList() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        LIST_USER_PROJECT,
        options: Options(
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $user_token'},
        ),
      );
      print('response');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
          print(jsonData);
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
            ProjectList = jsonData['data'];
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

  List selectedindex = [];
  List projectIdList = [];
  List formIdList = [];

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
          'Create User',
          style: TextStyle(fontSize: 20, fontFamily: 'nunito-sans-extrabold', color: Color(0xff212529), fontWeight: FontWeight.w700),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('$ICON_URL/Group 73619.png', height: 20, width: 20)),
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
            colors: const [Color(0xff442E7A)],
            strokeWidth: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldUser(
                  mWidth: mWidth,
                  controller: userName,
                  hintText: 'Username',
                  labelText: 'User',
                  labelText1: '',
                  mHeight: 50,
                ),
                SizedBox(height: 10),
                textFieldUser(
                  mWidth: mWidth,
                  controller: email,
                  hintText: 'abc@xyz.com',
                  labelText: 'Email',
                  labelText1: '',
                  mHeight: 50,
                ),
                SizedBox(height: 10),
                textFieldUser(
                  mWidth: mWidth,
                  controller: password,
                  hintText: 'Password',
                  labelText: 'Password',
                  labelText1: '',
                  mHeight: 50,
                ),
                SizedBox(height: 10),
                textFieldUser(
                  mWidth: mWidth,
                  controller: cPassword,
                  hintText: 'Password',
                  labelText: 'Confirm Password',
                  labelText1: '',
                  mHeight: 50,
                ),
                SizedBox(height: 10),
                textFieldUser(
                  mWidth: mWidth,
                  controller: phone,
                  hintText: 'Phone number',
                  labelText: 'Phone number',
                  labelText1: 'Optional',
                  mHeight: 50,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AppText(
                    text: 'User type',
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'nunito-sans-semibold',
                  ),
                ),
                Container(
                  width: mWidth,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xffF8F9FA),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Color(0xffB5B7BC)),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _dropdownValues,
                    underline: SizedBox(),
                    hint: Text(
                      "Select user",
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'nunito-sans-semibold',
                        fontSize: 13,
                      ),
                    ),
                    icon: Image.asset(
                      "$ICON_URL/Path 1135.png",
                      height: 15,
                      width: 15,
                    ),
                    onChanged: (newValue) async {
                      if (mounted) {
                        setState(() {
                          _dropdownValues = newValue;
                        });
                      }
                      if (_dropdownValues == 'Collaborator') {
                        setState(() {
                          userType = 0;
                          role_id = 1;
                        });
                      }
                      if (_dropdownValues == 'Reader') {
                        setState(() {
                          userType = 1;
                          role_id = 2;
                        });
                      }
                      print(userType);
                      print(_dropdownValues);
                    },
                    items: userTypeList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Access to information',
                        color: Colors.black,
                        fontFamily: 'nunito-sans-extrabold',
                        fontSize: 17,
                      ),
                      AppText(
                        text: 'Definehow much information the user will have access to',
                        color: Colors.black45,
                        fontFamily: 'nunito-sans-regular',
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AppText(
                    text: 'Projects',
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'nunito-sans-semibold',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isShow == false) {
                      setState(() {
                        isShow = true;
                      });
                    } else {
                      setState(() {
                        isShow = false;
                      });
                    }
                  },
                  child: Container(
                    width: mWidth,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xffF8F9FA),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Color(0xffB5B7BC)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select projects",
                          style: TextStyle(color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13),
                        ),
                        Image.asset(
                          "$ICON_URL/Path 1135.png",
                          height: 15,
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                isShow == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          width: mWidth,
                          height: 150,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xffF8F9FA),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black45),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: ProjectList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (selectedindex.contains(index)) {
                                            selectedindex.remove(index);
                                            if (projectIdList.contains(ProjectList[index]["project_id"])) {
                                              projectIdList.remove(ProjectList[index]["project_id"]);
                                            }
                                            print('remove $projectIdList');
                                          } else {
                                            selectedindex.add(index);
                                            projectIdList.add(ProjectList[index]["project_id"]);
                                            print('projectIdList');
                                            print(projectIdList);
                                          }
                                          setState(() {});
                                          print(ProjectList[index]["project_id"]);
                                          projectWiseFormList(projectId: projectIdList.join(','));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                selectedindex.contains(index)
                                                    ? Image.asset(
                                                        "$ICON_URL/Group 73565.png",
                                                        height: 18,
                                                        width: 18,
                                                      )
                                                    : Image.asset(
                                                        "$ICON_URL/Ellipse 90.png",
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                SizedBox(width: 15),
                                                Text(
                                                  ProjectList[index]['project_name'] ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AppText(
                    text: 'Form',
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'nunito-sans-semibold',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isShowForm == false) {
                      setState(() {
                        isShowForm = true;
                      });
                    } else {
                      setState(() {
                        isShowForm = false;
                      });
                    }
                  },
                  child: Container(
                    width: mWidth,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xffF8F9FA),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Color(0xffB5B7BC)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select form",
                          style: TextStyle(color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13),
                        ),
                        Image.asset(
                          "$ICON_URL/Path 1135.png",
                          height: 15,
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                isShowForm == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          width: mWidth,
                          height: 150,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xffF8F9FA),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black45),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: formList.length == 0
                                    ? Container(
                                        child: Center(
                                          child: Text(
                                            "No form found",
                                            style: TextStyle(color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: formList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (selectedformindex.contains(index)) {
                                                selectedformindex.remove(index);
                                                if (formIdList.contains(formList[index]["form_id"])) {
                                                  formIdList.remove(formList[index]["form_id"]);
                                                  formProjectId.remove(formList[index]["project_id"]);
                                                }
                                                print('removeformid $formIdList');
                                                print('removeformid $formProjectId');
                                              } else {
                                                selectedformindex.add(index);
                                                formIdList.add(formList[index]["form_id"]);
                                                formProjectId.add(formList[index]["project_id"]);
                                                print('formIdList');
                                                print(formIdList);
                                                print(formProjectId);
                                              }
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    selectedformindex.contains(index)
                                                        ? Image.asset(
                                                            "$ICON_URL/Group 73565.png",
                                                            height: 18,
                                                            width: 18,
                                                          )
                                                        : Image.asset(
                                                            "$ICON_URL/Ellipse 90.png",
                                                            height: 18,
                                                            width: 18,
                                                          ),
                                                    SizedBox(width: 15),
                                                    Text(
                                                      formList[index]['form_name'] ?? '',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                CustomButton(
                  fontFamily: 'nunito-sans-semibold',
                  width: mWidth,
                  height: 50,
                  onPressed: () {
                    if (_userValidate(email: email.text, password: password.text, cpassword: cPassword.text, firstName: userName.text)) {
                      CreateUser();
                    }
                  },
                  borderRadius: 10,
                  backgroundcolor: Color(0xff442E7A),
                  title: 'Finish',
                  fontSize: 16,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _userValidate({
    required String firstName,
    required String email,
    required String password,
    required String cpassword,
  }) {
    if (firstName.isEmpty && email.isEmpty && password.isEmpty && cpassword.isEmpty) {
      Toasty.showtoast('Please Enter Information');
      return false;
    } else if (firstName.isEmpty) {
      Toasty.showtoast('Please Enter userName');
      return false;
    } else if (email.isEmpty) {
      Toasty.showtoast('Please Enter Email Address');
      return false;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toasty.showtoast('Please Enter Valid Email Address');
      return false;
    } else if (password.isEmpty) {
      Toasty.showtoast('Please Enter Password');
      return false;
    } else if (password.length < 6) {
      Toasty.showtoast('Password Must Contains 6 Characters');
      return false;
    } else if (cpassword.isEmpty) {
      Toasty.showtoast('Please Enter cPassword');
      return false;
    } else {
      return true;
    }
  }
}

class textFieldUser extends StatelessWidget {
  const textFieldUser({
    Key? key,
    required this.mWidth,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLine,
    required this.mHeight,
    this.labelText1,
  }) : super(key: key);

  final double mWidth;
  final double mHeight;
  final controller;
  final hintText;
  final labelText;
  final labelText1;
  final maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        labelText == ''
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: labelText,
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'nunito-sans-semibold',
                    ),
                    AppText(
                      text: labelText1,
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'nunito-sans-semibold',
                    ),
                  ],
                ),
              ),
        Container(
          height: mHeight,
          width: mWidth,
          decoration: BoxDecoration(
            color: Color(0xffF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffB5B7BC)),
          ),
          child: TextField(
            controller: controller,
            // maxLines: maxLine,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF8F9FA),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
