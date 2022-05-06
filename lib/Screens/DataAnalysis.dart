import 'package:flutter/material.dart';
import 'package:supervisor_english_app/Components/CustomWidget.dart';
import 'package:supervisor_english_app/Utils/Constants.dart';

class DataAnalysisScreen extends StatefulWidget {
  @override
  _DataAnalysisScreenState createState() => _DataAnalysisScreenState();
}

class _DataAnalysisScreenState extends State<DataAnalysisScreen> {
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
          'Data Analysis',
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'nunito-sans-extrabold',
              color: Color(0xff212529),
              fontWeight: FontWeight.w700),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('$ICON_URL/Group 73619.png',
                  height: 20, width: 20)),
        ),
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Container(
                width: mWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Martinez Barios Family',
                            fontFamily: 'nunito-sans-extrabold',
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          SizedBox(height: 5),
                          AppText(
                            text: 'Cartagena,Bolivar',
                            fontFamily: 'nunito-sans-semibold',
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffFDEEEA)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                              child: AppText(
                                text: 'STATE OF PROGRESS',
                                fontFamily: 'nunito-sans-extrabold',
                                color: Color(0xffE76443),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          AppText(
                            text: 'Encounter #1',
                            fontFamily: 'nunito-sans-semibold',
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
