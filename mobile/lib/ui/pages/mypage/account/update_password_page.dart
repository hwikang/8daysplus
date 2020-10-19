import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/text_styles.dart';
import '../../../../utils/validator.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';

class UpdatePasswordPage extends StatefulWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
              color: Colors.black,
            ),
          ),
          title: const HeaderTitleWidget(title: '비밀번호 변경'),
          actions: <Widget>[
            UpdatePasswordSubmit(
              formKey: UpdatePasswordPage._formKey,
              passwordController: _passwordController,
              oldPasswordController: _oldPasswordController,
            )
          ],
        ),
        body: UpdatePasswordBody(
          formKey: UpdatePasswordPage._formKey,
          passwordController: _passwordController,
          oldPasswordController: _oldPasswordController,
        ));
  }
}

class UpdatePasswordSubmit extends StatelessWidget {
  const UpdatePasswordSubmit(
      {this.formKey, this.oldPasswordController, this.passwordController});

  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final updatePasswordBloc = UpdatePasswordBloc();
        if (formKey.currentState.validate()) {
          final model = UpdatePasswordModel(
              oldPassword: oldPasswordController.text,
              newPassword: passwordController.text);
          updatePasswordBloc
              .update(model)
              .then((value) => {
                    if (value)
                      {
                        DialogWidget.buildDialog(
                            context: context,
                            title: '비밀번호 변경이 완료되었습니다',
                            onPressed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            })
                      }
                  })
              .catchError((error) {
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
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(
              '완료',
              style: TextStyles.black14TextStyle,
            ),
          )),
    );
  }
}

class UpdatePasswordBody extends StatelessWidget {
  const UpdatePasswordBody(
      {this.formKey, this.oldPasswordController, this.passwordController});

  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 비밀번호',
                          style: TextStyles.grey14TextStyle,
                        ),
                        TextFormFieldWidget(
                          obscureText: true,
                          // keyboardType: TextInputType.visiblePassword,
                          textEditingController: oldPasswordController,
                          hintText: '8~15자리의 영문,숫자 조합',
                          validator: FieldValidator.validatePassword,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '새 비밀번호',
                              style: TextStyles.grey14TextStyle,
                            ),
                            TextFormFieldWidget(
                              obscureText: true,
                              textEditingController: passwordController,
                              hintText: '8~15자리의 영문,숫자 조합',
                              validator: (input) {
                                FieldValidator.validateNewPassword(
                                    input, oldPasswordController.text);
                              },
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '비밀번호 재입력',
                              style: TextStyles.grey14TextStyle,
                            ),
                            TextFormFieldWidget(
                              obscureText: true,
                              hintText: '8~15자리의 영문,숫자 조합',
                              validator: (input) {
                                return FieldValidator.validateConfirmPassword(
                                    input, passwordController.text);
                              },
                            ),
                          ])),
                ],
              ),
            )));
  }
}
