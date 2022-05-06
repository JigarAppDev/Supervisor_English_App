import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';
import 'CreateNewForm.dart';
import 'FormScreen.dart';

class CreateNewProject extends StatefulWidget {
  @override
  _CreateNewProjectState createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {

  var createProjectFieldTap;
  var projectNameTap;
  List<bool> isVisible = [];
  List ProjectList = [];
  var formname;
  bool isLoading = false;
  var user_token;


  TextEditingController projectName = TextEditingController();
  TextEditingController formName = TextEditingController();


  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    await getUserProjectList();
  }

  @override
  void initState() {
    super.initState();
    getUserToken();
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: mWidth,
                      decoration: BoxDecoration(color: Color(0xff5B4293), borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Create new Project',
                              color: Colors.white,
                              fontFamily: 'nunito-sans-extrabold',
                              fontSize: 20,
                            ),
                            SizedBox(height: 10),
                            AppText(
                              text: 'Create new Project where you can manage all yours forms',
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
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                  barrierColor: Colors.black45,
                                  transitionDuration: const Duration(milliseconds: 200),
                                  pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                                    return _displayTextInputDialog(context: context);
                                  },
                                );
                              },
                              borderRadius: 10,
                              backgroundcolor: Color(0xff442E7A),
                              title: 'Create project',
                              textColor: Colors.white,
                              fontSize: 15,
                              icon: 'Button.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: ProjectList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff5B4293),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            projectName = TextEditingController(text: ProjectList[index]['project_name'] ?? '');
                                          });

                                          print('projectName');
                                          print(projectName.text);
                                          showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                            barrierColor: Colors.black45,
                                            transitionDuration: const Duration(milliseconds: 200),
                                            pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                                              return _displayTextInputDialog(
                                                context: context,
                                                project_id: ProjectList[index]['project_id'],
                                                flag: 1,
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/icons/vuesax-broken-edit.png',
                                          height: 25,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          deleteProject(project_id: ProjectList[index]['project_id']);
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
                              child: GestureDetector(
                                onTap: () {
                                  print('tests');
                                  if (isVisible[index] == false) {
                                    setState(() {
                                      isVisible[index] = true;
                                    });
                                  } else {
                                    setState(() {
                                      isVisible[index] = false;
                                    });
                                    for (var i = 0; i < isVisible.length; i++) {
                                      if (index == i) {
                                      } else {
                                        setState(() {
                                          isVisible[i] = true;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: mWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: isVisible[index] == false ? true : false,
                                        child: Container(
                                          height: 2,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xffE65B37),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                        child: Row(
                                          children: [
                                            Visibility(
                                              visible: isVisible[index] == true ? true : false,
                                              child: Container(
                                                height: 20,
                                                width: 2,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffE65B37),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: AppText(
                                                text: ProjectList[index]['project_name'],
                                                fontFamily: 'nunito-sans-semibold',
                                                color: Colors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Visibility(
                                              visible: isVisible[index] == false ? true : false,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (isVisible[index] == false) {
                                                    setState(() {
                                                      isVisible[index] = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isVisible[index] = false;
                                                    });
                                                  }
                                                },
                                                child: Image.asset('$ICON_URL/vuesax-broken-minus.png', height: 20, width: 30),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: isVisible[index] == true ? false : true,
                                        child: ListView.builder(
                                          itemCount: ProjectList[index]['project_data'].length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index1) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 6),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => FormScreen(
                                                                    formId: ProjectList[index]['project_data'][index1]['form_id'],
                                                                  )));
                                                    },
                                                    child: Container(
                                                      width: mWidth,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.black26),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black12,
                                                            offset: const Offset(5.0, 5.0),
                                                            blurRadius: 10.0,
                                                            spreadRadius: 2.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height: 20,
                                                                  width: 2,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xffE65B37),
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 15),
                                                                AppText(
                                                                  text: ProjectList[index]['project_data'][index1]['form_name'] ?? '',
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
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: isVisible[index] == true ? false : true,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                          child: CustomButton(
                                            fontFamily: 'nunito-sans-semibold',
                                            width: mWidth,
                                            height: 50,
                                            onPressed: () {
                                              showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                barrierColor: Colors.black45,
                                                transitionDuration: const Duration(milliseconds: 200),
                                                pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                                                  return formNameDialog(
                                                    context: context,
                                                    project_id: ProjectList[index]['project_id'],
                                                  );
                                                },
                                              );
                                            },
                                            borderRadius: 10,
                                            backgroundcolor: Color(0xff442E7A),
                                            title: 'Create new form',
                                            textColor: Colors.white,
                                            fontSize: 15,
                                            icon: 'Button.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Future getUserProjectList() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    projectName.clear();
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
            for (var i in ProjectList) {
              isVisible.add(true);
            }
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

  Future deleteProject({var project_id}) async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        DELETE_PROJECT,
        data: {'project_id': project_id},
        options: Options(
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $user_token'},
        ),
      );
      print('response');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
          print('jsonData');
          print(jsonData);
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
            Toasty.showtoast(jsonData['msg']);
            getUserProjectList();
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

  void CreateProject() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        ADD_PROJECT,
        data: {
          'project_name': projectName.text,
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
          projectName.clear();
          isLoading = false;
          getUserProjectList();
          Navigator.pop(context);
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

  bool validate({required String Project}) {
    if (Project.isEmpty) {
      Toasty.showtoast('Please Enter Project Name');
      return false;
    } else {
      return true;
    }
  }

  bool validate1({required String Project}) {
    if (Project.isEmpty) {
      Toasty.showtoast('Please Enter Form Name');
      return false;
    } else {
      return true;
    }
  }

  FutureOr onGoBack(dynamic value) {
    formName.clear();
    getUserProjectList();
    setState(() {});
  }

  StatefulBuilder formNameDialog({required BuildContext context, var project_id}) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 170,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    maxLines: 6,
                    controller: formName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontFamily: 'nunito-sans-regula',
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Form Name',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'nunito-sans-extrabold',
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      fontFamily: 'nunito-sans-extrabold',
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 27,
                      onPressed: () {
                        Navigator.pop(context);
                        formName.clear();
                      },
                      borderRadius: 5,
                      backgroundcolor: Color(0xff5B4293),
                      title: 'Cancle',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                    CustomButton(
                      fontFamily: 'nunito-sans-extrabold',
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 27,
                      onPressed: () async {
                        if (validate1(Project: formName.text)) {
                          // CreateForm();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateNewForm(
                                        formName: formName.text,
                                        projectId: project_id,
                                      )));
                        }
                      },
                      borderRadius: 5,
                      backgroundcolor: Color(0xff5B4293),
                      title: 'Continue',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  StatefulBuilder _displayTextInputDialog({required BuildContext context, var project_id, var flag}) {
    return StatefulBuilder(builder: (context, setState) {
      Future editProject() async {
        print('project_id');
        print(project_id);
        late Response response;
        Dio dio = Dio();
        var jsonData;
        setState(() {
          isLoading = true;
        });
        try {
          response = await dio.post(
            EDIT_PROJECT,
            data: {
              'project_name': projectName.text,
              'project_id': project_id,
            },
            options: Options(
              headers: {"Accept": "application/json", 'Authorization': 'Bearer $user_token'},
            ),
          );

          if (response.statusCode == 200) {
            setState(() {
              jsonData = jsonDecode(response.toString());
              print('jsonData');
              print(jsonData);
            });
            if (jsonData['success'] == 1) {
              isLoading = false;
              Navigator.pop(context);
              getUserProjectList();
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

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 170,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    maxLines: 6,
                    controller: projectName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontFamily: 'nunito-sans-regula',
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Project Name',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'nunito-sans-extrabold',
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      fontFamily: 'nunito-sans-extrabold',
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 27,
                      onPressed: () {
                        projectName.clear();
                        Navigator.pop(context);
                      },
                      borderRadius: 5,
                      backgroundcolor: Color(0xff5B4293),
                      title: 'Cancle',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                    CustomButton(
                      fontFamily: 'nunito-sans-extrabold',
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 27,
                      onPressed: () {
                        if (flag == 1) {
                          print('ifflag');
                          if (validate(Project: projectName.text)) {
                            editProject();
                          }
                        } else {
                          print('else');
                          if (validate(Project: projectName.text)) {
                            CreateProject();
                          }
                        }
                      },
                      borderRadius: 5,
                      backgroundcolor: Color(0xff5B4293),
                      title: 'Continue',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

void doNothing(BuildContext context) {}
