import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Components/AppDrawer.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'ManageProject/CreateNewProject.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';
import 'ManageUser/NewUserMain.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    var user_type = await getPrefData(key: 'user_type');
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
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/BG.png'))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              ManageContainer(
                mWidth: mWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewProject()));
                },
                text: 'Manage Projects',
                buttonTitle: 'Manage Projects',
                buttonColor: Color(0xff442E7A),
                ContainerColor: Color(0xff5B4293),
                description: 'You can create edit and manage all your form within 1 ormore project',
              ),
              SizedBox(height: 20),
              ManageContainer(
                mWidth: mWidth,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewUserMain()));
                },
                text: 'Manage users',
                buttonTitle: 'Manage users',
                buttonColor: Color(0xff442E7A),
                ContainerColor: Color(0xff5B4293),
                description: 'You can create and assign user to your different project and/or forms',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageContainer extends StatelessWidget {
  const ManageContainer({
    Key? key,
    required this.mWidth,
    this.ContainerColor,
    this.text,
    this.description,
    this.buttonTitle,
    this.onTap,
    this.buttonColor,
  }) : super(key: key);

  final double mWidth;
  final ContainerColor;
  final text;
  final description;
  final buttonTitle;
  final onTap;
  final buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mWidth,
      decoration: BoxDecoration(color: ContainerColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: text,
              color: Colors.white,
              fontFamily: 'nunito-sans-extrabold',
              fontSize: 20,
            ),
            SizedBox(height: 15),
            AppText(
              text: description,
              color: Color(0xffB684FF),
              fontFamily: 'nunito-sans-regular',
              fontSize: 15,
            ),
            SizedBox(height: 15),
            CustomButton(
              fontFamily: 'nunito-sans-semibold',
              width: mWidth,
              height: 50,
              onPressed: onTap,
              borderRadius: 10,
              backgroundcolor: buttonColor,
              title: buttonTitle,
              fontSize: 16,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
