import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Screens/HomeScreen.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class FormScreen extends StatefulWidget {
  final formName;
  final formId;

  const FormScreen({Key? key, this.formName, this.formId}) : super(key: key);
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  @override
  void initState() {
    super.initState();
    getUserToken();
  }

  var user_token;
  Future getUserToken() async {
    user_token = await getPrefData(key: 'UserToken');
    await fieldListApi();
  }

  bool isLoading = false;
  var formName;
  List updateFormJsonList = [];
  List updateImageJsonList = [];
  List _controller = [];
  List _controller_check = [];
  List _controller_option = [];
  bool selectedRadio = false;
  var fieldList = [];
  List<FormFieldModel> fieldData = [];
  double fieldHeight = 50;
  int fieldIndex = 0;
  var customerimage;
  var customerpicname;
  var _dropdownValues;
  TimeOfDay selectedTime = TimeOfDay.now();

  var userTypeList = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  Future fieldListApi() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    try {
      response = await dio.post(
        GET_FORM_DETAIL,
        data: {'form_id': widget.formId},
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $user_token',
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
          },
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
            formName = jsonData['info']['form_name'];
            fieldList = jsonDecode(jsonData['info']['form_json'].toString().replaceAll('&quot;', '\"'));

            for (int i = 0; i < fieldList.length; i++) {
              if (fieldList[i]['form_field_id'] == 21) {
                _controller_check.add('IMAGE');
                _controller.add('IMAGE');
              } else if (fieldList[i]['form_field_id'] == 14) {
                _controller_check.add(bool);
                _controller_option.add(false);
                _controller.add(TextEditingController());
              } else if (fieldList[i]['form_field_id'] == 20) {
                _controller_check.add(bool);
                _controller_option.add(false);
                _controller.add(double);
              } else if (fieldList[i]['form_field_id'] == 12) {
                _controller_check.add(bool);
                _controller_option.add(false);
                _controller.add(TextEditingController());
              } else {
                _controller_check.add(TextEditingController());
                _controller_option.add(TextEditingController());
                _controller.add(TextEditingController());
              }
              FormFieldModel formFieldModel = FormFieldModel(
                  fieldID: fieldList[i]['form_field_id'],
                  fieldType: fieldList[i]['type'],
                  fieldRequire: fieldList[i]['is_require'],
                  fieldAdd: fieldList[i]['add_field'].toString(),
                  fieldHeight: 100,
                  fieldText: 'Enter Something');
              fieldData.add(formFieldModel);
            }
          });
          print('Set Controller');
          print(_controller);
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

  Future updateFormJsonListApi() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });

    updateFormJsonList.clear();
    updateImageJsonList.clear();

    for (int i = 0; i < fieldData.length; i++) {
      print(_controller[i]);
      if (fieldData[i].fieldID == 21) {
        updateImageJsonList.add(_controller[i]);
        print(updateImageJsonList);
      } else {
        updateFormJsonList.add(
          fieldData[i].fieldID == 11
              ? {
                  'field_label': _controller[i],
                  'field_type': fieldData[i].fieldType,
                  'field_id': fieldData[i].fieldID,
                }
              : fieldData[i].fieldID == 14
                  ? {
                      'field_type': fieldData[i].fieldType,
                      'field_value': _controller_check[i],
                      'field_label': _controller[i].text,
                      'field_id': fieldData[i].fieldID,
                    }
                  : fieldData[i].fieldID == 12
                      ? {
                          'field_type': fieldData[i].fieldType,
                          'field_value': _controller_option[i],
                          'field_label': _controller[i].text,
                          'field_id': fieldData[i].fieldID,
                        }
                      : fieldData[i].fieldID == 20
                          ? {
                              'field_type': fieldData[i].fieldType,
                              'field_value': _controller[i],
                              'field_id': fieldData[i].fieldID,
                            }
                          : {
                              'field_label': _controller[i].text,
                              'field_type': fieldData[i].fieldType,
                              'field_id': fieldData[i].fieldID,
                            },
        );
      }
    }
    if (updateImageJsonList.length != 0) {
      uploadFormImageListApi();
    }

    try {
      response = await dio.post(
        UPDATE_FORM_DETAIL,
        data: {
          'form_id': widget.formId,
          'form_json': json.encode(updateFormJsonList),
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
          print('jsonData');
          print(jsonData);
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
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
    }
  }

  Future uploadFormImageListApi() async {
    late Response response;
    Dio dio = Dio();
    var jsonData;
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap(
      {
        'image': '',
      },
    );

    for (var i = 0; i < updateImageJsonList.length; i++) {
      print(updateImageJsonList[i]);
      var fileName = updateImageJsonList[i].toString().split('/').last;
      print('$fileName');
      formData.files.addAll([
        MapEntry("image", await MultipartFile.fromFileSync("${updateImageJsonList[i]}", filename: fileName)),
      ]);
    }

    try {
      response = await dio.post(
        ADD_MULTIPLE_IMAGE,
        data: formData,
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
          print('jsonData');
          print(jsonData);
        });
        if (jsonData['success'] == 1) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
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
      print(e.message);
      print(e.response);
    }
  }

  Container SingleLine(int index, TextEditingController textEditingController) {
    return Container(
        child: textField(
      readOnly: false,
      mWidth: MediaQuery.of(context).size.width,
      hintText: 'Enter something',
      labelText: fieldData[index].fieldType,
      controller: textEditingController,
      maxLine: 10,
      mHeight: 50,
    ));
  }

  Container SliderLine(int index, textEditingController) {
    return Container(
        child: _controller[index] != double
            ? Slider(
                value: _controller[index],
                max: 100,
                divisions: 5,
                label: _controller[index].round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _controller[index] = value;
                  });
                },
              )
            : Slider(
                value: 10,
                max: 100,
                divisions: 5,
                label: 10.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _controller[index] = value;
                  });
                },
              ));
  }

  Container DateLine(int index, TextEditingController textEditingController) {
    return Container(
        child: textField(
      readOnly: false,
      mWidth: MediaQuery.of(context).size.width,
      hintText: 'Enter something',
      labelText: fieldData[index].fieldType,
      controller: textEditingController,
      maxLine: 10,
      mHeight: 50,
    ));
  }

  Row CheckboxLine(int index, TextEditingController textEditingController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _controller_check[index] == bool
            ? Container(
                height: 50,
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    setState(() {
                      _controller_check[index] = value;
                    });
                  },
                ),
              )
            : Container(
                height: 50,
                alignment: Alignment.center,
                child: Checkbox(
                  value: _controller_check[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _controller_check[index] = value;
                    });
                  },
                ),
              ),
        textField(
          readOnly: false,
          mWidth: MediaQuery.of(context).size.width * 0.5,
          hintText: fieldData[index].fieldType,
          labelText: '',
          controller: textEditingController,
          maxLine: 10,
          mHeight: 50,
        ),
      ],
    );
  }

  Row OptionLine(int index, TextEditingController textEditingController) {
    return Row(
      children: [
        _controller_option[index] == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _controller_option[index] = false;
                  });
                },
                child: Image.asset(
                  "$ICON_URL/Ellipse 90.png",
                  height: 18,
                  width: 18,
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _controller_option[index] = true;
                  });
                },
                child: Image.asset(
                  "$ICON_URL/Group 73565.png",
                  height: 18,
                  width: 18,
                ),
              ),
        SizedBox(width: 15),
        textField(
          readOnly: false,
          mWidth: MediaQuery.of(context).size.width * 0.5,
          hintText: 'Enter something',
          labelText: '',
          controller: textEditingController,
          maxLine: 10,
          mHeight: 50,
        )
      ],
    );
  }

  Container MultiLine(int index, TextEditingController textEditingController) {
    return Container(
        child: textField(
      readOnly: false,
      mWidth: MediaQuery.of(context).size.width,
      hintText: 'Enter something',
      labelText: fieldData[index].fieldType,
      controller: textEditingController,
      maxLine: 10,
      mHeight: 120,
    ));
  }

  Container TimeLine(int index, TextEditingController textEditingController) {
    return Container(
        child: textField(
      readOnly: false,
      mWidth: MediaQuery.of(context).size.width,
      hintText: 'Enter something',
      labelText: fieldData[index].fieldType,
      controller: textEditingController,
      maxLine: 10,
      mHeight: 120,
    ));
  }

  Container DropDownLine(int index, textEditingController) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          "Select",
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
              _controller[index] = _dropdownValues;
            });
          }
        },
        items: userTypeList.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
      ),
    );
  }

  Column AddressLine(int index, TextEditingController textEditingController) {
    return Column(
      children: [
        textField(
          mWidth: MediaQuery.of(context).size.width,
          readOnly: false,
          hintText: 'Address Line 1',
          labelText: 'Address',
          controller: textEditingController,
          mHeight: 50,
        ),
      ],
    );
  }

  Column AddImage(int index, textEditingController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppText(
            fontSize: 13,
            color: Colors.black,
            fontFamily: 'nunito-sans-extrabold',
            text: 'Add Image',
          ),
        ),
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xffF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  XFile storeimage = await getImage();
                  setState(() {
                    customerimage = storeimage.path;
                    customerpicname = storeimage.name;
                    _controller[index] = customerimage;
                  });

                  print('Image Data Show');
                  print(textEditingController);
                  print(customerpicname);
                  print(customerimage);
                },
                child: _controller[index] != 'IMAGE'
                    ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_controller[index]),
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/icons/vuesax-broken-gallery.png',
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          AppText(text: 'Upload Image', color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13)
                        ],
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Future getImage() async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
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
          formName ?? '',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: fieldData.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      switch (fieldData[index].fieldID) {
                        case 1:
                          return SingleLine(index, _controller[index]);
                        case 2:
                          return MultiLine(index, _controller[index]);
                        case 8:
                          return DateLine(index, _controller[index]);
                        case 14:
                          return CheckboxLine(index, _controller[index]);
                        case 6:
                          return AddressLine(index, _controller[index]);
                        case 11:
                          return DropDownLine(index, _controller[index]);
                        case 21:
                          return AddImage(index, _controller[index]);
                        case 19:
                          return AddImage(index, _controller[index]);
                        case 20:
                          return SliderLine(index, _controller[index]);
                        default:
                          return SingleLine(index, _controller[index]);
                      }
                    }),
              ),
              CustomButton(
                fontFamily: 'nunito-sans-semibold',
                width: mWidth,
                height: 50,
                onPressed: () {
                  updateFormJsonListApi();
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
    );
  }
}

class FormFieldModel {
  FormFieldModel(
      {required this.fieldID,
      required this.fieldType,
      required this.fieldRequire,
      required this.fieldAdd,
      required this.fieldHeight,
      required this.fieldText});

  final int fieldID;
  final String fieldType;
  final bool fieldRequire;
  final String fieldAdd;
  final int fieldHeight;
  final String fieldText;
}
