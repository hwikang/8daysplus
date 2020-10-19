import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/button/white_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import 'delete_user_success_page.dart';

class DeleteUserConfirmPage extends StatelessWidget {
  Widget _buildDeleteButton(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 88 * MediaQuery.of(context).textScaleFactor,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '8DAYS+를 탈퇴하겠습니까?',
              style: TextStyles.black16BoldTextStyle,
            ),
            // SizedBox(
            //   height: 16 * MediaQuery.of(context).textScaleFactor,
            // ),
            Row(
              children: <Widget>[
                Container(
                  width: 152 * DeviceRatio.scaleWidth(context),
                  height: 48 * MediaQuery.of(context).textScaleFactor,
                  child: WhiteButtonWidget(
                    title: '아니오',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                    width: 152 * DeviceRatio.scaleWidth(context),
                    height: 48 * MediaQuery.of(context).textScaleFactor,
                    child: BlackButtonWidget(
                      title: '예',
                      onPressed: () {
                        final deleteUserBloc = DeleteUserBloc();
                        deleteUserBloc.deleteUser().then((res) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('token', null);
                          AppRoutes.push(context, DeleteUserSuccessPage());
                        }).catchError((error) {
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
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Mypage_Close_account');
    return Scaffold(
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
        title: const HeaderTitleWidget(title: '회원탈퇴 확인'),
      ),
      // bottomSheet: _buildDeleteButton(context),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Text(
                '8DAYS+ 회원 탈퇴 시 아래의 사항을 다시 한번 확인 하시기 바랍니다.',
                style: TextStyles.black20BoldTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '1. 탈퇴 시 회원님의 개인정보는 즉시 파기되며, 복구가 되지 않으므로 유의 하시기 바랍니다.',
                style: TextStyles.black14TextStyle,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                '2. 단 전자상거래 등에서의 소비자 보호에 관한 법률, 전자금융거래법, 통신비밀보호법 등 법령에서 일정기간 정보의 보관을 규정하는 경우는 아래와 같으며, 이 기간 동안 법령의 규정에 따라 개인정보를 보관하며, 본 정보를 다른 목적으로는 절대 이용하지 않습니다.',
                style: TextStyles.black14TextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '* 전자상거래 등에서 소비자 보호에 관한 법률\n- 계약 또는 청약철회 등에 관한 기록: 5년(전자상거래 등에서의 소비자보호에 관한 법률\n- 대금결제 및 재화 등의 공급에 관한 기록: 5년(전자상거래 등에서의 소비자보호에 관한 법률)\n- 소비자의 불만 또는 분쟁처리에 관한 기록: 3년(전자상거래 등에서의 소비자보호에 관한 법률)\n- 전자금융 거래에 관한 기록: 5년(전자금융거래법)\n- 거래정보의 수집/처리 및 이용 등에 관한 기록: 5년(신용정보의 이용 및 보호에 관한 법률)\n- 서비스 접속 및 이용기록: 3개월(통신비밀보호법)',
                style: TextStyles.black14TextStyle,
              ),
              // Expanded(
              //   child: Container(),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildDeleteButton(context),
    );
  }
}
