import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../../utils/validator.dart';
import '../dialog_widget.dart';
import '../text_form_field_widget.dart';

enum AuthPhoneState { NONE, AUTHENTICATING, DELAY, DONE }

class AuthPhoneWidget extends StatefulWidget {
  const AuthPhoneWidget({
    this.authPhoneState,
    this.setTime,
    this.authPhoneStateChange,
    this.countryCodeChange,
    this.changePhone,
    this.changeAuthCode,
    this.formKey,
    this.phoneTextEditingController,
    this.authCodeEditingController,
    this.sendSmsFunction,
  });

  final TextEditingController authCodeEditingController;
  final AuthPhoneState authPhoneState;
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneTextEditingController;
  final int setTime;

  final Function(AuthPhoneState) authPhoneStateChange;

  final Function(String) countryCodeChange;

  final Function(String) changePhone;

  final Function(String) changeAuthCode;

  final Future<bool> Function(String, String) sendSmsFunction;

  @override
  _AuthPhoneWidgetState createState() => _AuthPhoneWidgetState();
}

class _AuthPhoneWidgetState extends State<AuthPhoneWidget> {
  String authCode;
  String authenticationState;
  String countDown;
  String countryCode; //내부적으로도 가지고있음
  int periodicTime;
  String phone;
  bool show;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    countryCode = '+82';
    countDown = '00:00';
    periodicTime = widget.setTime;
    show = false;
  }

  void startPeriodicTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        periodicTime--;
        if (periodicTime < 0) {
          timer.cancel();
          widget.authPhoneStateChange(AuthPhoneState.AUTHENTICATING);

          setState(() {
            periodicTime = widget.setTime;
          });
        }
        final time = DateTime.fromMillisecondsSinceEpoch(periodicTime * 1000);

        setState(() {
          countDown = DateFormat.ms().format(time);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            padding: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe0e0e0), width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CountryCodePicker(
                    searchDecoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffe0e0e0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      // prefixIcon: Icon(Icons.accessibility)
                    ),
                    onChanged: (code) {
                      setState(() {
                        countryCode = code.toString();
                      });
                      widget.countryCodeChange(countryCode);
                    },
                    initialSelection: 'KR',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: true,
                    alignLeft: true,
                  ),
                ),
                Image.asset(
                  ImageAssets.arrowDownImage,
                  width: 12,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              TextFormFieldWidget(
                textEditingController: widget.phoneTextEditingController,
                hintText: MemberPageStrings.authPhone_inputPhoneHint,
                validator: (text) {
                  return FieldValidator.validateMobile(text);
                },
                onSaved: (text) {
                  widget.changePhone(text);
                },
                keyboardType: TextInputType.number,
              ),
              GestureDetector(
                onTap: widget.authPhoneState == AuthPhoneState.DELAY
                    ? () {}
                    : () {
                        if (widget.formKey.currentState.validate()) {
                          widget
                              .sendSmsFunction(countryCode,
                                  widget.phoneTextEditingController.text)
                              .then((dynamic result) {
                            if (result) {
                              widget.authPhoneStateChange(AuthPhoneState.DELAY);

                              startPeriodicTimer();
                            } else {
                              DialogWidget.buildDialog(
                                  context: context,
                                  title: CommonTexts.fail,
                                  subTitle1: ErrorTexts.failSendSms,
                                  buttonTitle: CommonTexts.confirmButton);
                            }
                          }).catchError((dynamic error) {
                            if (error.contains('error_msg')) {
                              final Map<String, dynamic> map =
                                  json.decode(error);

                              DialogWidget.buildDialog(
                                context: context,
                                title: CommonTexts.fail,
                                subTitle1: map['error_msg'],
                              );
                            } else {
                              DialogWidget.buildDialog(
                                context: context,
                                subTitle1: '$error',
                                title: CommonTexts.fail,
                              );
                            }
                          });
                        }
                      },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                      right: 12, top: 13, bottom: 13, left: 12),
                  child: Text(
                    widget.authPhoneState == AuthPhoneState.NONE
                        ? MemberPageStrings.authPhone_sendAuthCode
                        : MemberPageStrings.authPhone_resendAuthCode,
                    style: widget.authPhoneState == AuthPhoneState.DELAY
                        ? TextStyles.grey12BoldTextStyle
                        : TextStyles.orange12BoldTextStyle,
                  ),
                ),
              ),
            ],
          ),
          if (widget.authPhoneState == AuthPhoneState.DELAY)
            Text(
              MemberPageStrings.authPhone_sendAuthCodeSuccess,
              style: TextStyles.black12TextStyle,
            )
          else
            Container(),
          if (widget.authPhoneState == AuthPhoneState.NONE)
            Container()
          else
            Container(
              margin: const EdgeInsets.only(top: 18),
              child: TextFormFieldWidget(
                  textEditingController: widget.authCodeEditingController,
                  keyboardType: TextInputType.number,
                  onSaved: (text) {
                    widget.changeAuthCode(text);
                  },
                  onChanged: (text) {
                    widget.changeAuthCode(text);
                  },
                  hintText: MemberPageStrings.authPhone_inputAuthCode,
                  suffix: Container(
                      width: 56, child: Center(child: Text('$countDown')))),
            ),
        ],
      ),
    );
  }
}
