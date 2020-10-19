import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/device_ratio.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/singleton.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';

class EmailAuthPage extends StatelessWidget {
  const EmailAuthPage({this.email, this.processType});

  final String email;
  final String processType;

  Widget _buildAuthButton(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: BlackButtonWidget(
          title: MemberPageStrings.emailAuth_button,
          onPressed: () {
            final confirmAuthMailBloc = ConfirmEmailBloc();
            confirmAuthMailBloc
                .confirmAuthMail(email, 'EMPLOYEE')
                .then((retVal) {
              if (retVal) {
                DialogWidget.buildDialog(
                    context: context,
                    title: MemberPageStrings.emailAuth_auth,
                    subTitle1: MemberPageStrings.emailAuth_success,
                    onPressed: () {
                      Singleton.instance.userEmail = email;
                      switch (processType) {
                        case 'LOGIN':
                          AppRoutes.firstMainPage(context);
                          break;
                        case 'SIGNUP':
                          AppRoutes.signUpCompletePage(context);
                          break;

                        default:
                      }
                    });
              } else {
                DialogWidget.buildDialog(
                  context: context,
                  title: CommonTexts.fail,
                  subTitle1: MemberPageStrings.emailAuth_fail,
                );
              }
            }).catchError((error) {
              if (error.contains('error_msg')) {
                final Map<String, dynamic> map = json.decode(error);

                DialogWidget.buildDialog(
                  context: context,
                  title: '에러',
                  subTitle1: map['error_msg'],
                );
              } else {
                DialogWidget.buildDialog(
                  context: context,
                  subTitle1: '$error',
                  title: '에러',
                );
              }
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Sign_Up_EmailSent');
    return Container(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              var count = 0;
              Navigator.popUntil(context, (route) => count++ == 2);
            },
          ),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              MemberPageStrings.emailAuth_sendEmailSuccess,
              style: TextStyles.black20BoldTextStyle,
            ),
          ),
        ),
        bottomNavigationBar: _buildAuthButton(context),
        body: Stack(
          //fit:StackFit.loose,
          children: <Widget>[
            Container(
              //height: screenHeight,
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    MemberPageStrings.emailAuth_intro,
                    style: TextStyles.black19BoldTextStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    MemberPageStrings.emailAuth_guide,
                    style: TextStyles.black16TextStyle,
                  ),

                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 40,
                        ),
                        padding: EdgeInsets.all(20),
                        color: const Color(0xfff8f8f8),
                        width: 312 * DeviceRatio.scaleWidth(context),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                MemberPageStrings.id,
                                style: TextStyles.black14TextStyle,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                email,
                                style: TextStyles.black16TextStyle,
                              ),
                            ]),
                      )),

                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MemberPageStrings.emailAuth_retryGuide,
                          style: TextStyles.grey14TextStyle,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            final abloc = AuthEmailBloc();
                            abloc.authEmail(email).then((retVal) {
                              if (retVal) {
                                DialogWidget.buildDialog(
                                  context: context,
                                  title: MemberPageStrings.emailAuth_intro,
                                );
                              } else {
                                DialogWidget.buildDialog(
                                  context: context,
                                  title: MemberPageStrings.emailAuth_retryFail,
                                );
                              }
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                MemberPageStrings.emailAuth_retry,
                                style: TextStyles.grey14TextStyle,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 2, left: 5),
                                child: Image.asset(
                                  ImageAssets.arrowRightImage,
                                  width: 8,
                                  height: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _buildTwoButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
