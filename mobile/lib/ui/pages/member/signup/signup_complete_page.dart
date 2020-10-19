import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';

class SingUpCompletePage extends StatelessWidget {
  Widget _buildSignUpOk(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            alignment: Alignment.centerLeft,
            child: Text(
              '회원가입을 환영합니다.',
              style: TextStyles.black20BoldTextStyle,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            alignment: Alignment.centerLeft,
            child: Text(
              '액티비티, 자기개발, 심리상담, 재테크 등\n워라밸을 위한 다양한 경험을 시작 해보세요.',
              style: TextStyles.black16TextStyle,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
        child: BlackButtonWidget(
          title: '시작하기',
          onPressed: () {
            signUpBloc.saveInputValues().then((signUp) {
              AppRoutes.firstMainPage(context);
            }).catchError((dynamic error) {
              print('error $error');
              if (error.contains('error_msg')) {
                final Map<String, dynamic> map = json.decode(error);

                DialogWidget.buildDialog(
                  context: context,
                  title: '에러',
                  subTitle1: map['error_msg'],
                  buttonTitle: '확인',
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
    Analytics.analyticsScreenName('Sign_Up_Done');

    final _analyticsParameter = <String, dynamic>{
      'company_code': signUpBloc.getCorpCode(),
    };
    Analytics.analyticsLogEvent('sign_up', _analyticsParameter);
    return Container(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.only(left: 24),
          child: const HeaderTitleWidget(
            title: '회원가입 완료',
          ),
        ),
      ),
      body: _buildSignUpOk(context),
      bottomNavigationBar: _buildStartButton(context),
    ));
  }
}
