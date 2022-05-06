import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Screens/ManageProject/FormScreen.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class CreateNewForm extends StatefulWidget {
  final formName;
  final formId;
  final projectId;
  const CreateNewForm({Key? key, this.formName, this.formId, this.projectId}) : super(key: key);
  @override
  _CreateNewFormState createState() => _CreateNewFormState();
}

class _CreateNewFormState extends State<CreateNewForm> {
  List<bool> isVisible = [];
  var showContainer;
  List<bool> isTrue = [];

  TextEditingController SingleLine = TextEditingController();
  var singleLine = 1;
  var multiLine = 1;
  var Name = 1;
  var Address = 1;
  var email = 1;
  var date = 1;
  var phone = 1;
  FutureOr onGoBack(dynamic value) {
    addFormJsonList;
    setState(() {});
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  var user_token;
  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
  }

  bool isLoading = false;

  List fieldList = [];
  Future fieldListApi() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        LIST_FORM_FIELD,
        data: {'form_id': widget.formId},
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
            fieldList = jsonData['data'];
          });
          for (var i in fieldList) {
            isVisible.add(false);
            isTrue.add(false);
          }
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

  List selectedfieldList = [];
  Future selectedfieldListApi() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      // isLoading = true;
    });
    try {
      response = await dio.post(
        LIST_USER_FORM_FIELD,
        data: {'form_id': widget.formId},
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
            selectedfieldList = jsonData['data'];
          });
          for (var i in fieldList) {
            isVisible.add(false);
            isTrue.add(false);
          }
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

  List addFormJsonList = [];
  Future CreateForm() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        ADD_FORM,
        data: {
          'form_name': widget.formName,
          'project_id': widget.projectId,
          'form_json': json.encode(addFormJsonList),
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $user_token',
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormScreen(formId: jsonData['data'][0]['form_id'])),
            );
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
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
          widget.formName ?? '',
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
            colors: const [kPrimaryColor],
            strokeWidth: 2,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/BG.png'))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addFormJsonList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            child: AppText(
                              text: 'To start with the creation of the form press the "Add field"button',
                              maxLines: 4,
                              color: Colors.black38,
                              fontSize: 15,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: addFormJsonList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              addFormJsonList.removeAt(index);
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/icons/vuesax-broken-trash.png',
                                            height: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: mWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: addFormJsonList[index]['type'] ?? '',
                                            fontFamily: 'nunito-sans-extrabold',
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: mWidth,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF8F9FA),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.black26),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () async {
                          await fieldListApi();
                          showModalBottomSheet(
                            barrierColor: Colors.black38,
                            isScrollControlled: true,
                            elevation: 0,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return StatefulBuilder(builder: (BuildContext context, setState) {
                                return buildBottomModelSheet(context: context);
                              });
                            },
                          ).then((onGoBack));
                        },
                        child: Container(
                          width: mWidth,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: 'Add Field',
                                  fontFamily: 'nunito-sans-semibold',
                                  color: Colors.black,
                                ),
                                Image.asset(
                                  '$ICON_URL/Button.png',
                                  height: 35,
                                  width: 35,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    addFormJsonList.length == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CustomButton(
                              fontFamily: 'nunito-sans-semibold',
                              width: mWidth,
                              height: 50,
                              onPressed: () {
                                CreateForm();
                              },
                              borderRadius: 10,
                              backgroundcolor: Color(0xff442E7A),
                              title: 'End',
                              fontSize: 16,
                              textColor: Colors.white,
                            ),
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

  Widget buildBottomModelSheet({required BuildContext context, var formFieldList}) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          SizedBox(height: 200),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: fieldList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: boxDecoration,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      child: Row(
                                        children: [
                                          AppText(
                                            text: fieldList[index]['form_field_name'] ?? '',
                                            fontFamily: 'nunito-sans-semibold',
                                            color: Colors.black,
                                          ),
                                          Spacer(),
                                          Visibility(
                                            visible: isVisible[index] == true ? false : true,
                                            child: GestureDetector(
                                              onTap: () async {
                                                print('test');
                                                setState(() {
                                                  isVisible[index] = true;
                                                });
                                              },
                                              child: Image.asset(
                                                '$ICON_URL/Group 73621.png',
                                                height: 35,
                                                width: 35,
                                              ),
                                            ),
                                          ),
                                          isVisible[index] == true
                                              ? Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          addFormJsonList.add(
                                                            {
                                                              "form_field_id": fieldList[index]['form_field_id'],
                                                              "type": fieldList[index]['form_field_name'],
                                                              "is_require": isTrue[index],
                                                              "add_field": null,
                                                            },
                                                          );
                                                        });
                                                        print('addFormJsonList');
                                                        print(addFormJsonList);
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 35,
                                                        decoration: BoxDecoration(color: Color(0xffE65B37), borderRadius: BorderRadius.circular(20)),
                                                        child: Center(
                                                          child: AppText(
                                                            text: 'ADD',
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontFamily: 'nunito-sans-extrabold',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isVisible[index] = false;
                                                        });
                                                      },
                                                      child: Image.asset('$ICON_URL/vuesax-broken-minus.png', height: 35, width: 30),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: isVisible[index] == true ? true : false,
                                      child: Column(
                                        children: [
                                          Divider(color: Colors.black45),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black26)),
                                                  child: TextField(
                                                    controller: SingleLine,
                                                    maxLines: 10,
                                                    readOnly: true,
                                                    cursorColor: Colors.black38,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: 'Required',
                                                      fontFamily: 'nunito-sans-semibold',
                                                      color: Colors.black,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isTrue[index] == false) {
                                                            setState(() {
                                                              isTrue[index] = true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isTrue[index] = false;
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Image.asset(isTrue[index] == true ? '$ICON_URL/Group 73622.png' : '$ICON_URL/Group 73623.png', height: 35, width: 30),
                                                    ),
                                                  ],
                                                ),
                                                Divider(color: Colors.black45),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: 'Min Characters',
                                                      fontFamily: 'nunito-sans-semibold',
                                                      color: Colors.black,
                                                    ),
                                                    AppText(
                                                      text: '0',
                                                      fontFamily: 'nunito-sans-semibold',
                                                      color: Colors.black38,
                                                    ),
                                                  ],
                                                ),
                                                Divider(color: Colors.black45),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: 'Max Characters',
                                                      fontFamily: 'nunito-sans-semibold',
                                                      color: Colors.black,
                                                    ),
                                                    AppText(
                                                      text: '50',
                                                      fontFamily: 'nunito-sans-semibold',
                                                      color: Colors.black38,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

