import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class AppText extends StatelessWidget {
  final String text, fontFamily;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int maxLines;
  AppText(
      {this.fontSize = 14,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal,
      this.fontFamily = 'nunito-sans-bold',
      this.letterSpacing,
      this.textDecoration = TextDecoration.none,
      this.textAlign = TextAlign.start,
      this.maxLines = 100,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final String icon;
  final double height;
  final width;
  final double borderRadius;
  final onPressed;
  final buttononPressed;
  final backgroundcolor;
  final fontFamily;
  final textColor;
  final double fontSize;
  const CustomButton(
      {this.title = '',
      this.onPressed,
      this.icon = '',
      this.height = 56,
      this.borderRadius = 16.0,
      this.width,
      this.backgroundcolor,
      this.fontFamily,
      this.textColor,
      required this.fontSize,
      this.buttononPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: backgroundcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: icon == ''
          ? AppText(text: title, fontWeight: FontWeight.bold, fontSize: fontSize, fontFamily: fontFamily, color: textColor)
          : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: title, fontWeight: FontWeight.bold, fontSize: fontSize, fontFamily: fontFamily, color: textColor),
                  GestureDetector(onTap: buttononPressed, child: Image.asset('$ICON_URL/$icon', height: 35, width: 35)),
                ],
              ),
            ),
    );
  }
}

class textField extends StatelessWidget {
  const textField({
    Key? key,
    required this.mWidth,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLine,
    required this.mHeight,
    this.readOnly,
  }) : super(key: key);

  final double mWidth;
  final double mHeight;
  final controller;
  final hintText;
  final labelText;
  final maxLine;
  final readOnly;

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
                child: AppText(
                  text: labelText,
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'nunito-sans-extrabold',
                ),
              ),
        Container(
          height: mHeight,
          width: mWidth,
          decoration: BoxDecoration(
            color: Color(0xffF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLine,
            readOnly: readOnly,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF8F9FA),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black45, fontFamily: 'nunito-sans-semibold', fontSize: 13),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        ),
      ],
    );
  }
}
