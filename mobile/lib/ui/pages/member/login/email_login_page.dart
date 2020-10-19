import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../../utils/validator.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';
import 'member_email_find_page.dart';

class EmailLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Sign_In_InputID');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black,
                onPressed: () {
                  AppRoutes.pop(context);
                },
              ),
              title: const HeaderTitleWidget(
                  title: MemberPageStrings.login_title)),
          resizeToAvoidBottomPadding: false,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Provider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(loginProvider: LoginProvider()),
                  dispose: (context, bloc) => bloc.dispose(),
                  child: LoginUI(),
                )
              ])),
    );
  }
}

class LoginUI extends StatelessWidget {
  Widget _buildForm(BuildContext context, LoginBloc bloc) {
    return Column(children: <Widget>[
      const SizedBox(height: 40),
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: emailField(context, bloc),
      ),
      const SizedBox(height: 8),
      Container(
        child: passwordField(context, bloc),
      ),
      const SizedBox(height: 40),
      submitButton(context, bloc),
      GestureDetector(
          onTap: () {
            // AppRoutes.tempPasswordRequestPage(context);

            Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(builder: (context) {
                return EmailFindRequestPage();
              }),
            );
          },
          child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(
                  top: 16, bottom: 12, left: 16, right: 16),
              child: Text(
                MemberPageStrings.login_findIdGuide,
                style: TextStyles.grey14TextStyle,
              ))),
      GestureDetector(
          onTap: () {
            AppRoutes.tempPasswordRequestPage(context);
          },
          child: Container(
              alignment: Alignment.topCenter,
              // margin: const const EdgeInsets.all(16),
              child: Text(
                MemberPageStrings.login_findPasswordGuide,
                style: TextStyles.grey14TextStyle,
              ))),
    ]);
  }

  Widget emailField(BuildContext context, LoginBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.email,
        builder: (context, snapshot) {
          print('snapshot email $snapshot.data');

          return TextFormFieldWidget(
              onChanged: bloc.changeEmail,
              keyboardType: TextInputType.emailAddress,
              errorText: snapshot.error,
              hintText: MemberPageStrings.login_idHint,
              validator: FieldValidator.validateEmail);
        });
  }

  Widget passwordField(BuildContext context, LoginBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, snapshot) {
          print('snapshot password ${snapshot.data}');

          return TextFormFieldWidget(
            obscureText: true,
            onChanged: bloc.changePassword,
            errorText: snapshot.error,
            hintText: MemberPageStrings.login_passwordHint,
            validator: FieldValidator.validatePassword,
          );
        });
  }

  Widget submitButton(BuildContext context, LoginBloc bloc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BlackButtonWidget(
        title: MemberPageStrings.login_title,
        onPressed: () {
          if (bloc.getUserEmail() == null) {
            return;
          }

          bloc.submit().then((result) {
            AppRoutes.firstMainPage(context);
          }).catchError((dynamic error) {
            if (error.contains('error_msg')) {
              final Map<String, dynamic> map = json.decode(error);

              DialogWidget.buildDialog(
                  context: context,
                  title: '에러',
                  subTitle1: map['error_msg'],
                  buttonTitle: '확인',
                  onPressed: () {
                    if (map['error_code'] == 4012) {
                      final abloc = AuthEmailBloc();
                      abloc.authEmail(bloc.getUserEmail()).then((retVal) {
                        if (retVal) {
                          AppRoutes.emailAuthPage(
                              context, bloc.getUserEmail(), 'LOGIN');
                        } else {
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
            } else {
              DialogWidget.buildDialog(
                context: context,
                subTitle1: '$error',
                title: '에러',
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context);
    return Container(
      margin: const EdgeInsets.only(left: 24, top: 24, bottom: 40, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            MemberPageStrings.login_intro,
            style: TextStyles.black20BoldTextStyle,
          ),
          Form(child: _buildForm(context, bloc))
        ],
      ),
    );
  }
}
