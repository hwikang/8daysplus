import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';
import '../../../components/common/user/auth_phone_widget.dart';

// const int _timer = 10;

class UpdateUserInfoPage extends StatefulWidget {
  const UpdateUserInfoPage({this.prevName, this.prevBirthDay, this.prevPhone});

  final String prevBirthDay;
  final String prevName;
  final String prevPhone;

  @override
  _UpdateUserInfoPageState createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
  String authCode;
  AuthPhoneState authPhoneState;
  String birth;
  String countryCode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name;
  String phone;
  TextEditingController phoneTextEditingController;
  String prevBirthDay;
  int setTime;
  // int periodicTime;
  // String countDown;

  Timer timer;

  @override
  void initState() {
    print('widget.prevPhone ${widget.prevPhone}');
    super.initState();
    phoneTextEditingController = TextEditingController(
      text: widget.prevPhone,
    );
    prevBirthDay = widget.prevBirthDay.length > 6
        ? widget.prevBirthDay.substring(2)
        : widget.prevBirthDay;
    phone = '';
    authCode = '';
    countryCode = '+82';
    setTime = 10;
    authPhoneState = AuthPhoneState.NONE;
    // authenticationState = 'NONE';
    // periodicTime = _timer;
    // countDown = '';
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

  Widget _buildTextFiled({
    BuildContext context,
    String title,
    String hintText,
    Function validator,
    Function onSaved,
    TextInputType keyboardType,
    int maxLength,
    String initialValue,
  }) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyles.grey14TextStyle,
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormFieldWidget(
            maxLength: maxLength,
            hintText: hintText,
            validator: validator,
            onSaved: onSaved,
            keyboardType: keyboardType,
            initialValue: initialValue),
      ],
    ));
  }

  Widget _buildBottomSubmitButton(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: MediaQuery.of(context).size.width,
        child: BlackButtonWidget(
          title: '완료',
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              final bloc = UpdateProfileBloc();
              final cbloc = ConfirmMobileBloc();

              if (phoneTextEditingController.text != widget.prevPhone) {
                //auth check

                cbloc.confirmAuthSms(countryCode, phone, authCode).then((res) {
                  if (res) {
                    final bloc = UpdateProfileBloc();
                    bloc
                        .updateProfile(
                            name: name,
                            birthYear: birth.substring(0, 2),
                            birthMonth: birth.substring(2, 4),
                            birthDay: birth.substring(4, 6),
                            countryCode: countryCode,
                            mobile: phone)
                        .then((res) {
                      print(res);

                      Navigator.of(context).pop(true);
                    }).catchError((dynamic error) {
                      print('catched error $error');
                      if (error.contains('error_msg')) {
                        final Map<String, dynamic> map = json.decode(error);

                        DialogWidget.showAlert(
                            context: context, child: Text(map['error_msg']));
                      } else {
                        DialogWidget.showAlert(
                            context: context, child: Text(error));
                      }
                    });
                  }
                }).catchError((dynamic error) {
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
              } else {
                bloc
                    .updateProfile(
                        name: name,
                        birthYear: birth.substring(0, 2),
                        birthMonth: birth.substring(2, 4),
                        birthDay: birth.substring(4, 6),
                        countryCode: countryCode,
                        mobile: phone)
                    .then((res) {
                  if (res) {
                    Navigator.of(context).pop(true);
                  }
                }).catchError((dynamic error) {
                  print('catched error $error');

                  if (error.contains('error_msg')) {
                    final Map<String, dynamic> map = json.decode(error);

                    DialogWidget.showAlert(
                        context: context, child: Text(map['error_msg']));
                  } else {
                    DialogWidget.showAlert(
                        context: context, child: Text(error));
                  }
                });
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sendAuthMobileBloc = SendAuthSmsBloc();

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: ,
            titleSpacing: 0,
            elevation: 0,
            title: const HeaderTitleWidget(
              title: '추가 정보 수정',
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomSubmitButton(context),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 12,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildTextFiled(
                        context: context,
                        title: '이름',
                        hintText: '8daysplus@hanwha.com',
                        validator: (text) {
                          if (text == '' || text == null) {
                            return '입력 해주세요';
                          }
                          return null;
                        },
                        onSaved: (text) {
                          setState(() {
                            name = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        initialValue:
                            widget.prevName != '' ? widget.prevName : ''),
                    const SizedBox(
                      height: 40,
                    ),
                    _buildTextFiled(
                        context: context,
                        title: '생년월일',
                        hintText: '6자리 입력(예시:850429)',
                        validator: (text) {
                          if (text == '' || text == null) {
                            return '입력 해주세요';
                          }
                          if (text.length != 6) {
                            return '6자리 입력';
                          }
                          return null;
                        },
                        onSaved: (text) {
                          setState(() {
                            birth = text;
                          });
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        initialValue: prevBirthDay),
                    const SizedBox(
                      height: 40,
                    ),
                    Text('휴대폰 번호', style: TextStyles.grey14TextStyle),
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
                        sendSmsFunction: sendAuthMobileBloc.sendAuthSms
                        // periodicTimeChange: periodicTimeChange
                        ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
