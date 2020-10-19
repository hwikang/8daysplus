import 'package:flutter/material.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/header_title_widget.dart';

class DeleteUserSuccessPage extends StatelessWidget {
  Widget _buildButton(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: 312 * DeviceRatio.scaleWidth(context),
        child: BlackButtonWidget(
          title: '확인',
          onPressed: () {
            AppRoutes.firstMainPage(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.only(left: 24),
          child: const HeaderTitleWidget(
            title: '회원탈퇴 완료',
          ),
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                AppRoutes.firstMainPage(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  ImageAssets.closeImage,
                  width: 40,
                  color: Colors.black,
                ),
              )),
        ],
      ),
      bottomNavigationBar: _buildButton(context),
      body: Center(
        child: Text(
          '그동안 8DAYS+를 사랑해주셔서 감사합니다.\n8DAYS+ 계정 탈퇴가 완료되었습니다.',
          style: TextStyles.black14TextStyle,
        ),
      ),
    );
  }
}
