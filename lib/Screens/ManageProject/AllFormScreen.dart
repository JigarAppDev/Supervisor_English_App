import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/AppDrawer.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';
import 'FormScreen.dart';

class AllFormScreen extends StatefulWidget {
  final userId;

  const AllFormScreen({Key? key, this.userId}) : super(key: key);
  @override
  _AllFormScreenState createState() => _AllFormScreenState();
}

class _AllFormScreenState extends State<AllFormScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> isVisible = [];
  List ProjectList = [];
  bool isLoading = false;
  var user_token;


  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    await getUserProjectList();
  }

  @override
  void initState() {
    super.initState();
    getUserToken();
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
        LIST_PROJECT_BY_USERID,
        data: {'user_id': widget.userId},
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

  @override
  Widget build(BuildContext context) {
    final double mWidth = MediaQuery.of(context).size.width;
    final double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
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
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Image.asset('$ICON_URL/Button-1.png', height: 20, width: 20)),
        ),
      ),
      drawer: AppDrawer(),
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
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/BG.png'))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: mWidth * 0.42,
                        child: AppText(
                          text: 'Diligense is an organized easy way all your forms',
                          fontFamily: 'nunito-sans-semibold',
                          color: Colors.black,
                          fontSize: 15,
                          maxLines: 3,
                        ),
                      ),
                    ),
                    Container(
                      width: mWidth * 0.48,
                      child: Image.asset('$ICON_URL/Group 73624.png', fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      itemCount: ProjectList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
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
                                            text: ProjectList[index]['project_name'] ?? '',
                                            fontFamily: 'nunito-sans-semibold',
                                            color: Colors.black,
                                          ),
                                        ),
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
                                                onTap: () {
                                                  setState(() {});
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FormScreen(
                                                                formName: ProjectList[index]['project_data'][index1]['form_name'],
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
                                  isVisible[index] == false ? SizedBox(height: 20) : SizedBox(height: 0),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
