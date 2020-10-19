import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/firebase_analytics.dart';
import '../../../utils/routes.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/header_title_widget.dart';

class MyPointPage extends StatefulWidget {
  const MyPointPage({
    this.lifePointModel,
  });

  final LifePointModel lifePointModel;

  @override
  _MyPointPageState createState() => _MyPointPageState();
}

class _MyPointPageState extends State<MyPointPage>
    with SingleTickerProviderStateMixin {
  final NumberFormat formatter = NumberFormat('#,###');
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  Widget _buldTabList(List<LifePointListViewModel> list, String pointState) {
    List<LifePointListViewModel> properList;
    switch (pointState) {
      case 'ALL':
        properList = list;
        break;
      case 'USAGED':
        properList = list.where((item) {
          return item.type == 'USAGED';
        }).toList();
        break;
      case 'SAVED':
        properList = list.where((item) {
          return item.type == 'SAVED';
        }).toList();
        break;
      default:
    }
    return ListView.builder(
      itemCount: properList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 186 * DeviceRatio.scaleWidth(context),
                    child: Text(
                      properList[index].name,
                      style: TextStyles.black14TextStyle,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    child: properList[index].state == 'SAVE_COMPLETE'
                        ? Text('${formatter.format(properList[index].point)}P',
                            style: TextStyles.orange14BoldTextStyle)
                        : Text('${formatter.format(properList[index].point)}P',
                            style: TextStyles.black14BoldTextStyle),
                  ),
                ],
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    properList[index].createdAt,
                    style: TextStyles.grey12TextStyle,
                  ),
                  if (properList[index].state == 'SAVE_COMPLETE')
                    Text(
                      '소멸 D-${properList[index].expireDay}일',
                      style: TextStyles.orange12TextStyle,
                    )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopContainer(BuildContext context) {
    return Container(
      height: 85 * DeviceRatio.scaleRatio(context) + 68,
      color: const Color(0xff313537),
      padding: const EdgeInsets.only(top: 28, left: 24, bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '사용가능',
                  style: TextStyles.white14BoldTextStyle,
                ),
                Text(
                  '${formatter.format(widget.lifePointModel.lifePoint)}P',
                  style: TextStyle(
                      fontFamily: FontFamily.bold,
                      fontSize: 30,
                      color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            // color: Colors.red,
            height: 20 * DeviceRatio.scaleRatio(context),
            child: Row(
              children: <Widget>[
                Container(
                  width: 162,
                  // decoration: BoxDecoration(
                  // border: Border(
                  //     right: BorderSide(color: const Color(0xff606060)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '적립예정',
                        style: TextStyles.grey14TextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Text(
                          '${formatter.format(widget.lifePointModel.lifeTobeSavedPoint)}P',
                          style: TextStyles.grey14TextStyle,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 12 * DeviceRatio.scaleRatio(context),
                  color: const Color(0xff606060),
                ),
                Container(
                  width: 162,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          '소멸예정',
                          style: TextStyles.grey14TextStyle,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${formatter.format(widget.lifePointModel.lifeTobeExpiredPoint)}P',
                          style: TextStyles.grey14TextStyle,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Mypage_8Point');
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
          title: const HeaderTitleWidget(title: '8데이즈+ 포인트'),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                final myPageSettingProvider = MyPageSettingProvider();
                myPageSettingProvider.myPageSetting().then((info) {
                  // print(info.pointPolicyUrl);
                  AppRoutes.buildTitledModalBottomSheet(
                      context: context,
                      title: '포인트 정책 보기',
                      child: WebviewScaffold(
                        url: info['servicePolicyInfo'].pointPolicyUrl,
                      ));
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Center(
                  child: Text(
                    '포인트 정책 보기',
                    style: TextStyles.black14TextStyle,
                  ),
                ),
              ),
            )
          ],
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    _buildTopContainer(context),
                    Container(
                      height: 44,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 24),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0xffeeeeee)))),
                      child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        labelStyle: TextStyles.black14BoldTextStyle,
                        unselectedLabelStyle: TextStyles.grey14TextStyle,
                        unselectedLabelColor: const Color(0xffd0d0d0),
                        indicatorPadding: const EdgeInsets.only(right: 20),
                        labelPadding: const EdgeInsets.only(right: 20),
                        tabs: const <Widget>[
                          Tab(text: '전체'),
                          Tab(text: '사용내역'),
                          Tab(text: '적립내역'),
                        ],
                      ),
                    ),
                  ]),
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: <Widget>[
                _buldTabList(widget.lifePointModel.lifePointList, 'ALL'),
                _buldTabList(widget.lifePointModel.lifePointList, 'USAGED'),
                _buldTabList(widget.lifePointModel.lifePointList, 'SAVED'),
              ],
            )));
  }
}
