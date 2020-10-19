import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/text_form_field_widget.dart';

class CompanyCodePage extends StatefulWidget {
  CompanyCodePage({
    this.userEmail,
    this.userToken,
  });

  final String userEmail;
  final String userToken;

  @override
  _CompanyCodePageState createState() => _CompanyCodePageState();
}

class _CompanyCodePageState extends State<CompanyCodePage> {
  final TextEditingController companyCodeTextController =
      TextEditingController();
  String companyCode = '';
  @override
  void initState() {
    super.initState();
    companyCodeTextController.addListener(() {
      setState(() {
        companyCode = companyCodeTextController.text;
      });
    });
  }

  Widget _buildCompanyCodeBody(BuildContext context) {
    // final companyCodeTextController = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          Text(
            MemberPageStrings.companyCode_intro,
            style: TextStyle(
              color: const Color(0xff404040),
              fontFamily: FontFamily.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            MemberPageStrings.signUp_companyCode,
            style: TextStyle(
              color: const Color(0xff909090),
              fontFamily: FontFamily.regular,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormFieldWidget(
              obscureText: false,
              textEditingController: companyCodeTextController,
              hintText: MemberPageStrings.signUp_companyCodeHint,
              validator: (text) {
                return text.isEmpty ? ValidatorTexts.empty : null;
              }),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        child: BlackButtonWidget(
          title: CommonTexts.next,
          isUnabled: companyCode.isEmpty,
          onPressed: () {
            final existCompanyCodeBloc = ExistCompanyCodeBloc();
            existCompanyCodeBloc.existCompanyCode(companyCode).then((res) {
              if (res) {
                signUpBloc.saveCorpCode(companyCode);
                AppRoutes.memberPhonePage(context);
              } else {
                DialogWidget.buildDialog(
                    title: ErrorTexts.companyCodeNotExists,
                    context: context,
                    buttonTitle: CommonTexts.confirmButton);
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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('on tap');
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              MemberPageStrings.signUp_companyCodeHint,
              style: TextStyles.black20BoldTextStyle,
            ),
          ),
        ),
        bottomNavigationBar: _buildStartButton(context),
        body: SingleChildScrollView(child: _buildCompanyCodeBody(context)),
      ),
    );
  }
}
