import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

import 'CustomWidget.dart';

class DrawerTile extends StatelessWidget {
  DrawerTile({this.leadingIcon, this.title, this.onTap, this.selected});
  final leadingIcon;
  final title;
  final onTap;
  final selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 11),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(leadingIcon, height: 20),
            ),
            AppText(
              text: title,
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
