import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'payment_webview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/assets.dart';
import '../../../utils/handle_network_error.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';

class CustomerCenterWidget extends StatelessWidget {
  const CustomerCenterWidget({
    this.onlyKakao = false,
  });

  final bool onlyKakao;

  Future<void> _sendEmail(String email) async {
    try {
      await launch(email);
      // ignore: avoid_catches_without_on_clauses
    } on Exception catch (e) {
      print(e);
      throw 'Could not Call Phone';
    }
  }

  Widget _buildContainer(String assetImage, String title, Function onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        height: 64,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffeeeeee), width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Image.asset(assetImage),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  title,
                  style: TextStyles.black14BoldTextStyle,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          _buildContainer(
              ImageAssets.customerCenterKakao, ReservationPageStrings.kakao,
              () {
            final kakaoChannelBloc = KakaoChannelBloc();
            kakaoChannelBloc.getKakaoChannelURL().then((url) {
              AppRoutes.buildTitledModalBottomSheet(
                  context: context,
                  title: ReservationPageStrings.kakao,
                  child: PaymentWebview(
                    url: url,
                  ));
            }).catchError((error) {
              HandleNetworkError.showErrorDialog(context, error);
            });
          }),
          if (onlyKakao)
            Container()
          else
            _buildContainer(ImageAssets.customerCenterEmail, '이메일 문의하기', () {
              _sendEmail('mailto:gtention@hanwha.com');
            }),
        ],
      ),
    );
  }
}
