import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';

class MemberEmailGuidePage extends StatelessWidget {
  const MemberEmailGuidePage({this.snapEmail});

  final String snapEmail;

  Widget _buildOKButton(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.all(24),
          child: FlatButton(
              padding: const EdgeInsets.only(right: 5),
              onPressed: () {
                // 어디로 보냄? 로그인?
                var count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2; // 로그인으로
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    height: 46,
                    color: Colors.black,
                    child: Center(
                        child: Text(
                      '확인',
                      style: TextStyles.white14BoldTextStyle,
                    )),
                  )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arr = snapEmail.split(',');
    final name = arr[1];
    final email = arr[0];
    return Container(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Container(
            margin: const EdgeInsets.only(left: 24),
            alignment: Alignment.centerLeft,
            child: Text(
              '이메일 아이디 안내',
              style: TextStyles.black20BoldTextStyle,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () {
                // AppRoutes.pop(context);
                var count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2; // 로그인으로
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: _buildOKButton(context),
        body: Container(
          //height: screenHeight,
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$name 님의\n아이디는 아래와 같습니다.',
                style: TextStyles.black20BoldTextStyle,
                maxLines: 2,
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                  // height: 92 * MediaQuery.of(context).textScaleFactor,
                  width: 312 * DeviceRatio.scaleWidth(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Container(
                      color: const Color(0xfff8f8f8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              MemberPageStrings.id,
                              style: TextStyles.black14TextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              email,
                              style: TextStyles.black16TextStyle,
                            ),
                          ]),
                    ),
                  )),
              // Expanded(
              //   child: Container(),
              // ),
              // _buildOKButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
