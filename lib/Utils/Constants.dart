import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String IMG_URL = 'assets/images';
const String ICON_URL = 'assets/icons';
const Color kPrimaryColor = Color(0xffAEA2C7);

final khintTextStyle1 = TextStyle(
  fontSize: 13,
  fontFamily: 'nunito-sans-semibold',
  fontWeight: FontWeight.w900,
  color: Color(0xff5B4293),
);

final khintTextStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'nunito-sans-regular',
  fontWeight: FontWeight.bold,
  color: Color(0xFF242A2E).withOpacity(0.5),
);

final boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(color: Colors.black26),
);

Future setPrefData({required String key, required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future getPrefData({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data;
}

Future clearPrefData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

class Toasty {
  static showtoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.5));
  }
}

/// APIs
const BaseURL = 'http://54.165.154.132:4000/users';
const LOGIN = "$BaseURL/login";
const LOGOUT = "$BaseURL/log_out";
const ADD_PROJECT = "$BaseURL/add_project";
const ADD_FORM = "$BaseURL/add_form";
const DELETE_PROJECT = "$BaseURL/delete_project";
const LIST_FORM_FIELD = "$BaseURL/list_form_field";
const LIST_USER_FORM_FIELD = "$BaseURL/list_user_form_field";
const ADD_FORM_FIELD = "$BaseURL/add_form_field";
const ADD_USER_FORM_FIELD = "$BaseURL/add_user_form_field";
const DELETE_USER_FORM_FIELD = "$BaseURL/delete_user_form_field";
const EDIT_PROJECT = "$BaseURL/edit_project";
const GET_FORM_DETAIL = "$BaseURL/get_form_details";
const UPDATE_FORM_DETAIL = "$BaseURL/update_form_details";
const ADD_MULTIPLE_IMAGE = "$BaseURL/add_multiple_image";

///createuser
const LIST_FORM = "$BaseURL/list_form";
const ADDUSER = "$BaseURL/add_user";
const LIST_USER_PROJECT = "$BaseURL/list_user_project";
const LIST_USER = "$BaseURL/list_user";
const LIST_PROJECT_BY_USERID = "$BaseURL/get_access_project_list";
const LIST_PROJECT_BY_USER = "$BaseURL/list_form_by_user";
