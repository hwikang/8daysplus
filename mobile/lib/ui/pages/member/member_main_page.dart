import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/powered_bottom_widget.dart';
import '../../components/member/social_login_buttons_widget.dart';

class MemberMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Sign_In');
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).padding.top), //status bar
          Expanded(
            child: Container(),
          ),
          Container(
            child: Image(
              image: AssetImage(ImageAssets.memberImage),
              width: 176,
              height: 63,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            MemberPageStrings.mainSubTitle,
            style: TextStyles.black18TextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: const SocialLoginButtonsWidget(),
            // child: _buildThreeButton(context)
          ),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : AppRoutes.firstMainPage(context);
              },
              child: Text(MemberPageStrings.withoutLogin,
                  style: TextStyles.grey14TextStyle)),
          const SizedBox(height: 32),
          GestureDetector(
              onTap: () {
                AppRoutes.signUpPage(context);
              },
              child: Text(MemberPageStrings.messageSignup,
                  style: TextStyles.grey14TextStyle)),
          Expanded(
            child: Container(),
          ),
          PoweredBottomWidget(),
        ],
      )),
    );
  }
}
