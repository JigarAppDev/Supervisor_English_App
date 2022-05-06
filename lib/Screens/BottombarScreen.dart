import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Screens/DataAnalysis.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class BottombarScreen extends StatefulWidget {
  @override
  _BottombarScreenState createState() => _BottombarScreenState();
}

class _BottombarScreenState extends State<BottombarScreen> {

  int _selectedIndex = 2;

  static List<Widget> body = [
    Container(),
    Container(),
    DataAnalysisScreen(),
    Container(),
    Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: body.elementAt(_selectedIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff5B4293),
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: BottomIcon(icon: 'vuesax-broken-edit-1'),
                activeIcon: BottomIcon(icon: 'uesax-broken-edit')),
            BottomNavigationBarItem(
                label: '',
                icon: BottomIcon(icon: 'vuesax-broken-export-1'),
                activeIcon: BottomIcon(icon: 'vuesax-broken-export')),
            BottomNavigationBarItem(
                label: '',
                icon: BottomIcon(icon: 'vuesax-broken-filter-tick-1'),
                activeIcon: BottomIcon(icon: 'vuesax-broken-filter-tick')),
            BottomNavigationBarItem(
                label: '',
                icon: BottomIcon(icon: 'vuesax-broken-import-1'),
                activeIcon: BottomIcon(icon: 'vuesax-broken-import')),
            BottomNavigationBarItem(
                label: '',
                icon: BottomIcon(icon: 'vuesax-broken-import-3'),
                activeIcon: BottomIcon(icon: 'vuesax-broken-import-2')),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          onTap: (value) {},
          elevation: 5,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final String icon;
  BottomIcon({this.icon = ''});

  @override
  Widget build(BuildContext context) {
    return Image.asset('$ICON_URL/$icon.png', height: 22, width: 22);
  }
}
