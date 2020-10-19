import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_styles.dart';
import '../../components/common/border_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';

class MyPageAlarmPage extends StatelessWidget {
  const MyPageAlarmPage({this.alarmAgreementModel});

  final AlarmAgreementModel alarmAgreementModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AlarmAgreementModel>(
        stream: Provider.of<MySettingBloc>(context).alarmAgreement,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(body: LoadingWidget());
          }
          return AlarmSettingListWidget(alarmAgreementModel: snapshot.data);
        });
  }
}

class AlarmSettingListWidget extends StatefulWidget {
  const AlarmSettingListWidget({this.alarmAgreementModel});

  final AlarmAgreementModel alarmAgreementModel;

  @override
  _AlarmSettingListWidgetState createState() => _AlarmSettingListWidgetState();
}

class _AlarmSettingListWidgetState extends State<AlarmSettingListWidget> {
  bool customerAlarm;
  bool marketingAlarm;
  bool orderAlarm;

  @override
  void initState() {
    super.initState();
    marketingAlarm = widget.alarmAgreementModel.marketingAlarm;
    orderAlarm = widget.alarmAgreementModel.orderAlarm;
    customerAlarm = widget.alarmAgreementModel.customerAlarm;
    // LoadAlarmData(marketingAlarm, orderAlarm, customerAlarm);
  }

  Widget buildSwitchContainer(BuildContext context, String text, String summary,
      Function onChange, bool value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          Container(
              height: 32 * MediaQuery.of(context).textScaleFactor,
              // margin: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Text(
                      '$text',
                      style: TextStyles.black16TextStyle,
                    ),
                  ),
                  Center(
                    child: Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        onChanged: onChange,
                        value: value,
                        activeColor: const Color(0xffffffff),
                        activeTrackColor: const Color(0xff313537),
                        inactiveThumbColor: const Color(0xffffffff),
                        inactiveTrackColor: const Color(0xfff4f4f4),
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 17,
          ),
          Container(
            child: Text(
              '$summary',
              maxLines: 2,
              style: TextStyles.grey12TextStyle,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          BoarderWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('marketingAlarm $marketingAlarm');
    print('orderAlarm $orderAlarm');
    print('customerAlarm $customerAlarm');

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(
            context,
            AlarmAgreementModel(
                marketingAlarm: marketingAlarm,
                orderAlarm: orderAlarm,
                customerAlarm: customerAlarm));
        return Future<bool>.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(
                  context,
                  AlarmAgreementModel(
                      marketingAlarm: marketingAlarm,
                      orderAlarm: orderAlarm,
                      customerAlarm: customerAlarm));
            },
          ),
          title: const HeaderTitleWidget(title: '알람 설정'),
        ),
        body: StreamBuilder<AlarmAgreementModel>(
          stream: Provider.of<MySettingBloc>(context).alarmAgreement,
          builder: (context, repoSnapshot) {
            if (!repoSnapshot.hasData) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildSwitchContainer(context, '마케팅 정보 수신 동의',
                        '다양한 혜택, 실시간 할인정보 등의 유용한 알림 서비스를 받아 보실 수 있습니다.',
                        (newValue) async {
                      setState(() {
                        marketingAlarm = newValue;
                      });
                      // Singleton.instance.alarmCenter1 = marketingAlarm;
                    }, marketingAlarm),
                    buildSwitchContainer(
                        context, '주문 정보', '회원님께서 주문한 주문 및 환불 정보를 받아보실 수 있습니다.',
                        (newValue) async {
                      setState(() {
                        orderAlarm = newValue;
                      });
                      // Singleton.instance.alarmCenter1 = marketingAlarm;
                    }, orderAlarm),
                    buildSwitchContainer(
                        context, '고객 센터', '문의한 내역 확인 및 정보를 안내 받아보실 수 있습니다.',
                        (newValue) async {
                      setState(() {
                        customerAlarm = newValue;
                      });
                      // Singleton.instance.alarmCenter1 = marketingAlarm;
                    }, customerAlarm),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
