import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/handle_network_error.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';

class MainAlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Notification');
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
        title: const HeaderTitleWidget(title: AlarmPageStrins.alarm),
      ),
      body: AlarmListWidget(),
    );
  }
}

class AlarmListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<MainAlarmBloc>(
      create: (context) => MainAlarmBloc(
        first: 20,
      ),
      child: AlarmListWidgetDetail(),
    );
  }
}

class AlarmListWidgetDetail extends StatefulWidget {
  @override
  _AlarmListWidgetDetailState createState() => _AlarmListWidgetDetailState();
}

class _AlarmListWidgetDetailState extends State<AlarmListWidgetDetail> {
  bool isLoading;

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    _scrollController.addListener(() {
      // print(_scrollController.position.pixels);
      // print(_scrollController.position.maxScrollExtent);
      final bloc = Provider.of<MainAlarmBloc>(context);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('scrool event');
        if (bloc.networkState.value != NetworkState.Finish) {
          bloc.getMoreAlarm();
        }
      }
    });
  }

  @override
  void initState() {
    print('init');
    super.initState();
    isLoading = false;
  }

  void toggleLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
    print('isloading $isLoading');
  }

  Widget buildAlarm(
    FeedMainAlarmModel alarm,
  ) {
    switch (alarm.type) {
      case 'COMPLETE_COUPON':
        return AlarmTextWidget(
          AlarmPageStrins.completeCoupon,
          ImageAssets.mainAlarmCouponImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {},
        );
        break;
      case 'EXPIRED_COUPON':
        return AlarmTextWidget(
          AlarmPageStrins.expiredCoupon,
          ImageAssets.mainAlarmCouponImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {},
        );
        break;
      case 'REPLY_INQUIRY':
        return AlarmTextWidget(
          AlarmPageStrins.replyInquiry,
          ImageAssets.mainAlarmInquryImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.inquiryListPage(context);
          },
        );

        break;
      case 'EXPIRED_POINT':
        return AlarmTextWidget(
          AlarmPageStrins.expiredPoint,
          ImageAssets.mainAlarmPointImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {},
        );

        break;

      case 'CANCEL_RESERVE':
        return AlarmWidget(
          AlarmPageStrins.cancelReserve,
          ImageAssets.mainAlarmReserCancelImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'COMPLETE_REFUND':
        return AlarmWidget(
          AlarmPageStrins.completeRefund,
          ImageAssets.mainAlarmRefundImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'REQUEST_REFUND':
        return AlarmWidget(
          AlarmPageStrins.requestRefund,
          ImageAssets.mainAlarmRefundImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'PENDING_REFUND':
        return AlarmWidget(
          AlarmPageStrins.pendingRefund,
          ImageAssets.mainAlarmRefundImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'PENDING_RESERVE':
        return AlarmWidget(
          AlarmPageStrins.pendingReserve,
          ImageAssets.mainAlarmReserOkImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'COMPLETE_RESERVE':
        return AlarmWidget(
          AlarmPageStrins.completeReserve,
          ImageAssets.mainAlarmReserOkImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      case 'COMPLETE_PAYMENT':
        return AlarmWidget(
          AlarmPageStrins.completePayment,
          ImageAssets.mainAlarmReserOkImage,
          alarm,
          isLoading,
          toggleLoadingState,
          onClick: () {
            AppRoutes.myOrderDetailPage(context, alarm.actionLink.value);
          },
        );

        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkState>(
        stream: Provider.of<MainAlarmBloc>(context).networkState,
        builder: (context, networkState) {
          print('alarm networkState ${networkState.data}');
          return HandleNetworkError.handleNetwork(
            state: networkState.data,
            context: context,
            retry: () {
              print('retry');
              Provider.of<MainAlarmBloc>(context).fetch();
            },
            child: StreamBuilder<List<FeedMainAlarmModel>>(
                stream: Provider.of<MainAlarmBloc>(context).repoList,
                builder: (context, repoSnapshot) {
                  if (!repoSnapshot.hasData || repoSnapshot.data.isEmpty) {
                    return Container(
                        margin:
                            const EdgeInsets.only(top: 50, left: 24, right: 24),
                        child: const Center(
                          child: Text('존재하는 알림이 없습니다.'),
                        ));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: repoSnapshot.data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == repoSnapshot.data.length) {
                        if (networkState.data != NetworkState.Finish) {
                          return Container(
                              child: const Center(
                                  heightFactor: 3, child: LoadingWidget()));
                        }
                        return Container();
                      }
                      // print('networkState.data ${networkState.data} $index');
                      return buildAlarm(repoSnapshot.data[index]);
                    },
                  );
                }),
          );
        });
  }
}

class AlarmWidget extends StatelessWidget {
  const AlarmWidget(this.title, this.imageAsset, this.model, this.isLoading,
      this.toggleLoadingState,
      {this.onClick});

  final String imageAsset;
  final bool isLoading;
  final FeedMainAlarmModel model;
  final Function onClick;
  final String title;
  final Function toggleLoadingState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? () {}
          : () {
              toggleLoadingState();
              onClick();
              toggleLoadingState();
            },
      child: Container(
        height: 158 * DeviceRatio.scaleRatio(context),
        margin: const EdgeInsets.only(top: 25, bottom: 8, left: 24, right: 24),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image(
                  width: 20,
                  height: 20,
                  image: AssetImage(imageAsset),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(title, style: TextStyles.black12BoldTextStyle),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(model.createdAt,
                        style: TextStyles.grey12TextStyle),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 28),
              child: Text(model.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.black13TextStyle),
            ),
            BottomContainerBox(model: model),
          ],
        ),
      ),
    );
  }
}

class AlarmTextWidget extends StatelessWidget {
  const AlarmTextWidget(this.title, this.imageAsset, this.model, this.isLoading,
      this.toggleLoadingState,
      {this.onClick});

  final String imageAsset;
  final bool isLoading;
  final FeedMainAlarmModel model;
  final Function onClick;
  final String title;
  final Function toggleLoadingState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toggleLoadingState();
        onClick();
        toggleLoadingState();
      },
      child: Container(
        color: Colors.transparent,
        height: 62 * DeviceRatio.scaleRatio(context),
        margin: const EdgeInsets.only(top: 25, bottom: 8, left: 24, right: 24),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image(
                  width: 20,
                  height: 20,
                  image: AssetImage(ImageAssets.mainAlarmInquryImage),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(title, style: TextStyles.black12BoldTextStyle),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(model.createdAt,
                        style: TextStyles.grey12TextStyle),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 28),
              child: Text(model.name,
                  // '임의 텍스트 테스트 2줄까지 가능 임의 텍스트 테스트 2줄까지 가능 임의 텍스트 테스트 2줄까지 가능',
                  maxLines: 2,
                  style: TextStyles.black14TextStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomContainerBox extends StatelessWidget {
  const BottomContainerBox({this.model});

  final FeedMainAlarmModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80 * DeviceRatio.scaleRatio(context),
      margin: const EdgeInsets.only(left: 28, top: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffe0e0e0), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: const Color(0xffffffff),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                height: 56,
                width: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(model.message.coverImage.url,
                      fit: BoxFit.cover),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    width: 190,
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: Text(
                      model.message.name,
                      // 'asdasdasesaczczxvdqfsdafqdsaasdqwfasfzdsadqwdasdasdascascasdqwdqwxcz',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.black12TextStyle,
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsets.only(left: 12),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${model.message.price.toString()}원',
                      style: TextStyles.black12BoldTextStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
