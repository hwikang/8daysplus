import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../../utils/validator.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController companyCodeTextController =
      TextEditingController();

  final TextEditingController emailTextController = TextEditingController();
  bool isFilled;
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController realNameTextController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isFilled = false;
  }

  void isFilledCheck() {
    if (emailTextController.text != '' &&
        passwordTextController.text != '' &&
        companyCodeTextController.text != '' &&
        realNameTextController.text != '') {
      setState(() {
        isFilled = true;
      });
    } else {
      setState(() {
        isFilled = false;
      });
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              MemberPageStrings.signUp_intro,
              style: TextStyles.black19BoldTextStyle,
            ),
          ),
          Form(
            key: _formKey,
            child: _buildTextForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final existEmailBloc = ExistEmailBloc();

    return SafeArea(
        child: Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      // width: 312 * DeviceRatio.scaleWidth(context),
      child: BlackButtonWidget(
        title: CommonTexts.next,
        isUnabled: !isFilled,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signUpBloc.saveLoginType('EMAIL');
            existEmailBloc
                .existEmail(emailTextController.text, signUpBloc.getLoginType(),
                    '', companyCodeTextController.text)
                .then((res) {
              getLogger(this).i(
                  'existCompanyCode ${res["existsCompanyCode"]} existsEmail ${res["existsEmail"]}');

              if (!res['existsCompanyCode']) {
                DialogWidget.buildDialog(
                    context: context,
                    title: ErrorTexts.companyCodeNotExists,
                    buttonTitle: CommonTexts.confirmButton);
              } else {
                if (res['existsEmail']) {
                  DialogWidget.buildDialog(
                      context: context,
                      title: ErrorTexts.emailExists,
                      buttonTitle: CommonTexts.confirmButton);
                } else {
                  signUpBloc.saveIdPassword(
                    emailTextController.text.trim(),
                    passwordTextController.text,
                  );
                  signUpBloc.saveName(realNameTextController.text);
                  signUpBloc.saveCorpCode(companyCodeTextController.text);
                  signUpBloc.saveLoginType('EMAIL');
                  AppRoutes.memberPhonePage(context);
                }
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
          }
        },
      ),
    ));
  }

  Widget _buildTextForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: Text(
            MemberPageStrings.id,
            style: TextStyles.grey14TextStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormFieldWidget(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              textEditingController: emailTextController,
              hintText: MemberPageStrings.signUp_idHint,
              onChanged: (text) {
                isFilledCheck();
              },
              validator: FieldValidator.validateEmail),
        ),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: Text(
            MemberPageStrings.signUp_password,
            style: TextStyles.grey14TextStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormFieldWidget(
              obscureText: true,
              textEditingController: passwordTextController,
              hintText: MemberPageStrings.signUp_passwordHint,
              onChanged: (text) {
                isFilledCheck();
              },
              validator: FieldValidator.validatePassword),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
          child: TextFormFieldWidget(
              obscureText: true,
              // textEditingController: passwordTextController,
              hintText: '**********',
              onChanged: (text) {
                isFilledCheck();
              },
              validator: (input) {
                if (input != passwordTextController.text) {
                  return ValidatorTexts.differentPasswordError;
                }
                return null;
              }),
        ),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: Text(
            MemberPageStrings.signUp_companyCode,
            style: TextStyles.grey14TextStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormFieldWidget(
              obscureText: false,
              textEditingController: companyCodeTextController,
              hintText: MemberPageStrings.signUp_companyCodeHint,
              onChanged: (text) {
                isFilledCheck();
              },
              validator: (text) {
                return text.isEmpty ? ValidatorTexts.empty : null;
              }),
        ),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
          child: Text(
            MemberPageStrings.signUp_name,
            style: TextStyles.grey14TextStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormFieldWidget(
              keyboardType: TextInputType.text,
              obscureText: false,
              textEditingController: realNameTextController,
              hintText: MemberPageStrings.signUp_nameHint,
              onChanged: (text) {
                isFilledCheck();
              },
              validator: (text) {
                return text.isEmpty ? ValidatorTexts.empty : null;
              }),
        ),
        const SizedBox(
          height: 56,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Sign_Up_Register');
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title:
              const HeaderTitleWidget(title: MemberPageStrings.signUp_title)),
      bottomNavigationBar: _buildButton(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
        // _buildBody(context),
      ),
    );
  }
}
