import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import 'email_login_page.dart';

class TempPasswordCompletePage extends StatelessWidget {
  const TempPasswordCompletePage(this.email);

  final String email;

  Widget _buildUI(
    BuildContext context,
    String email,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          MemberPageStrings.tempPasswordCompleteIntro,
          style: TextStyles.black20BoldTextStyle,
        ),
        const SizedBox(height: 12),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                email,
                style: TextStyles.orange16TextStyle,
              ),
              Text(
                MemberPageStrings.tempPasswordCompleteMessage,
                style: TextStyles.black16TextStyle,
              ),
            ])
      ],
    );
  }

  Widget submitButton(BuildContext context) {
    return SafeArea(
        child: Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: BlackButtonWidget(
        title: CommonTexts.confirmButton,
        onPressed: () => AppRoutes.popUntil(context, 2),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
        ),
        bottomNavigationBar: submitButton(context),
        body: Container(
            margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildUI(context, email),
                  // Expanded(child: Container()),
                  Container(
                    child: Text(
                      MemberPageStrings.tempPasswordGuideMessage,
                      style: TextStyles.black14TextStyle,
                    ),
                  )
                ])));
  }
}
