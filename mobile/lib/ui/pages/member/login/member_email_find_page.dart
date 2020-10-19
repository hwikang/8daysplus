import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/user/auth_phone_widget.dart';
import 'member_email_guide_page.dart';

class EmailFindRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                AppRoutes.pop(context);
              },
            ),
            title: const HeaderTitleWidget(
                title: MemberPageStrings.findEmail_title)),
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              margin: const EdgeInsets.all(24), child: BuildBodyWidget()),
        )));
  }
}

class BuildBodyWidget extends StatefulWidget {
  @override
  _BuildUIState createState() => _BuildUIState();
}

class _BuildUIState extends State<BuildBodyWidget> {
  String authCode;
  TextEditingController authCodeEditingController;
  AuthPhoneState authPhoneState;
  String countryCode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone;
  TextEditingController phoneTextEditingController;
  int setTime;

  @override
  void initState() {
    super.initState();
    countryCode = '+82';
    setTime = 10;
    authPhoneState = AuthPhoneState.NONE;
    phoneTextEditingController = TextEditingController();
    authCodeEditingController = TextEditingController();
  }

  void authPhoneStateChange(AuthPhoneState state) {
    setState(() {
      authPhoneState = state;
    });
  }

  void countryCodeChange(String code) {
    setState(() {
      countryCode = code;
    });
  }

  void changePhone(String number) {
    setState(() {
      phone = number;
    });
  }

  void changeAuthCode(String code) {
    setState(() {
      authCode = code;
    });
  }

  Widget _buildNextButton(BuildContext context) {
    return SafeArea(
        child: BlackButtonWidget(
      title: CommonTexts.next,
      isUnabled: authCodeEditingController.text == '',
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();

          final confirmAuthEmailSMSBloc = ConfirmAuthEmailBloc();
          confirmAuthEmailSMSBloc
              .confirmAuthEmail(countryCode, phone, authCode)
              .then((retString) {
            print(retString);
            if (retString != null) {
              if (retString.toString().contains('@') &&
                  retString.toString().contains('.') &&
                  retString.toString().contains(',')) {
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(builder: (context) {
                    return MemberEmailGuidePage(
                      snapEmail: retString,
                    );
                  }),
                );
              } else {
                DialogWidget.buildDialog(
                    context: context,
                    title: CommonTexts.inform,
                    subTitle1: MemberPageStrings.findEmail_fail);
              }
            }
          }).catchError((dynamic error) {
            if (error.contains('error_msg')) {
              final Map<String, dynamic> map = json.decode(error);

              DialogWidget.buildDialog(
                context: context,
                title: ErrorTexts.error,
                subTitle1: map['error_msg'],
              );
            } else {
              DialogWidget.buildDialog(
                context: context,
                subTitle1: '$error',
                title: ErrorTexts.error,
              );
            }
          });
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final sendAuthSmsBloc = SendAuthSmsBloc();
    return Scaffold(
        bottomNavigationBar: _buildNextButton(context),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MemberPageStrings.findEmail_intro,
                          style: TextStyles.black20BoldTextStyle,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          MemberPageStrings.findEmail_guide,
                          style: TextStyles.black16TextStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Text(
                      MemberPageStrings.findEmail_phoneNumber,
                      style: TextStyles.grey14TextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AuthPhoneWidget(
                      authPhoneState: authPhoneState,
                      setTime: setTime,
                      // countDown: countDown,
                      formKey: formKey,
                      authPhoneStateChange: authPhoneStateChange,
                      countryCodeChange: countryCodeChange,
                      changePhone: changePhone,
                      changeAuthCode: changeAuthCode,
                      phoneTextEditingController: phoneTextEditingController,
                      authCodeEditingController: authCodeEditingController,
                      sendSmsFunction: sendAuthSmsBloc.sendAuthEmailSms),
                ],
              ),
            ),
          ),
        ));
  }
}
