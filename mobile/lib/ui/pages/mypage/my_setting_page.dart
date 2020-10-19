import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:mobile/ui/components/common/payment_webview.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/one_signal_client.dart';
import '../../../utils/routes.dart';
import '../../../utils/singleton.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/dialog_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../modules/common/handle_network_module.dart';
import 'my_page_alarm_page.dart';

class MySettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: '설정'),
      ),
      body: Provider<MySettingBloc>(
        create: (context) => MySettingBloc(),
        child: SettingListWidget(),
      ),
    );
  }
}

class SettingListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mySettingBloc = Provider.of<MySettingBloc>(context);

    return HandleNetworkModule(
      retry: mySettingBloc.fetch,
      networkState: mySettingBloc.networkState,
      child: StreamBuilder<ServicePolicyInfoModel>(
        stream: mySettingBloc.servicePolicyInfo,
        builder: (context, repoSnapshot) {
          if (!repoSnapshot.hasData) {
            return const LoadingWidget();
          }

          final item = repoSnapshot.data;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                _buildMenuTitle('서비스 설정', context),
                _buildMenu('알림 설정', context, () {
                  final myPageSettingBloc = Provider.of<MySettingBloc>(context);
                  Navigator.of(context)
                      .push<AlarmAgreementModel>(
                    MaterialPageRoute<AlarmAgreementModel>(
                        builder: (context) => Provider<MySettingBloc>(
                              create: (context) => MySettingBloc(),
                              child: const MyPageAlarmPage(),
                            )),
                  )
                      .then((value) {
                    getLogger(this).d('value ${value.toJSON()}');

                    Analytics.analyticsSetUserProperty(
                        UserPropertyStrings.marketingAgree,
                        value.marketingAlarm.toString());

                    OneSignalClient.instance.sendTag(
                        UserPropertyStrings.marketingAgree,
                        value.marketingAlarm.toString());

                    myPageSettingBloc.updateAlarmAgreement(value).then((res) {
                      if (res) {
                        print('res $res');
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
                  });
                }),
                const SizedBox(
                  height: 48,
                ),
                _buildMenuTitle('서비스 정책안내', context),
                _buildMenu('서비스 이용약관', context, () {
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '서비스 이용약관',
                      child: PaymentWebview(
                        url: item.serviceUseTermsUrl,
                      ));
                }),
                _buildMenu('쿠폰 이용 정책', context, () {
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '쿠폰 이용 정책',
                      child: WebviewScaffold(
                        url: item.couponPolicyUrl,
                      ));
                }),
                _buildMenu('포인트 정책', context, () {
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '포인트 정책',
                      child: WebviewScaffold(
                        url: item.pointPolicyUrl,
                      ));
                }),
                _buildMenu('개인정보 처리방침', context, () {
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '개인정보 처리방침',
                      child: WebviewScaffold(
                        url: item.personalInfoUrl,
                      ));
                }),
                _buildMenu('위치기반 정보 이용약관', context, () {
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '위치기반 정보 이용약관',
                      child: WebviewScaffold(
                        url: item.locationUseTermsUrl,
                      ));
                }),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color(0xffeeeeee),
                  ))),
                  margin: const EdgeInsets.only(left: 28, right: 28),
                  padding: EdgeInsets.only(top: 18, bottom: 18),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '앱버전',
                            style: TextStyles.black14TextStyle,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: Text(
                          Singleton.instance.appVersion,
                          style: TextStyles.orange14BoldTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuTitle(String text, BuildContext context) {
    return Container(
      // alignment: Alignment.centerLeft,
      width: 312 * DeviceRatio.scaleWidth(context),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xff404040),
      ))),
      margin: const EdgeInsets.only(left: 24, right: 24),
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyles.black18BoldTextStyle,
      ),
    );
  }

  Widget _buildMenu(String text, BuildContext context, Function onTap,
      {String highlight}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // alignment: Alignment.centerLeft,
        width: 312 * DeviceRatio.scaleWidth(context),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color(0xffeeeeee),
        ))),
        margin: const EdgeInsets.only(left: 24, right: 24),
        padding: const EdgeInsets.only(bottom: 18, top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyles.black14TextStyle,
            ),
            Image.asset(
              ImageAssets.arrowRightImage,
              width: 6,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
