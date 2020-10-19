import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/header_title_widget.dart';

class MyCouponPage extends StatefulWidget {
  const MyCouponPage({this.couponInfo});

  final CouponModel couponInfo;

  @override
  _MyCouponPageState createState() => _MyCouponPageState();
}

class _MyCouponPageState extends State<MyCouponPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  Widget _buildCouponList(BuildContext context, List<CouponListViewModel> list,
      String couponState) {
    List<CouponListViewModel> properList;
    switch (couponState) {
      case 'SAVED':
        properList = list.where((item) {
          return item.state == 'SAVED';
        }).toList();

        break;
      case 'USAGED':
        properList = list.where((item) {
          return item.state == 'USAGED' || item.state == 'EXPIRED';
        }).toList();
        break;

      default:
    }
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: ListView.builder(
          itemCount: properList.length,
          itemBuilder: (context, index) {
            String dDayText;
            switch (properList[index].state) {
              case 'SAVED':
                dDayText = 'D-${properList[index].remainDay}';
                break;
              case 'USAGED':
                dDayText = '사용완료';
                break;
              case 'EXPIRED':
                dDayText = '기간만료';
                break;

              default:
            }
            return Container(
              // height: 140 * DeviceRatio.scaleRatio(context),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffeeeeee), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 18 * DeviceRatio.scaleRatio(context),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Text(
                              dDayText,
                              style: TextStyles.black12BoldTextStyle,
                            ),
                          ),
                          Text('${properList[index].expireDate}까지',
                              style: TextStyles.black12TextStyle),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 27 * DeviceRatio.scaleRatio(context) * 2,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.9,
                          child: Text(
                            properList[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.black18BoldTextStyle,
                          ),
                        ),
                        Text(
                          properList[index].discountUnit == 'PERCENT'
                              ? '${properList[index].discountAmount}%'
                              : '${properList[index].discountAmount}원',
                          style: TextStyles.orange18BoldTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Container(
                      // height: 24 * DeviceRatio.scaleRatio(context),
                      child: _buildSummary(properList[index].summary))
                ],
              ),
            );
          }),
    );
  }

  Widget _buildSummary(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.grey12TextStyle,
    );
  }

  Widget addCouponContainer(BuildContext context) {
    return Container(
        height: 112,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xfff8f8f8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: BlackButtonWidget(
          title: '쿠폰 등록',
          onPressed: () {
            AppRoutes.applyCouponPage(context);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Mypage_Coupon');
    return Scaffold(
        backgroundColor: Colors.white,
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
          title: const HeaderTitleWidget(title: '8데이즈+ 쿠폰'),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  addCouponContainer(context),
                  Container(
                    height: 44 * DeviceRatio.scaleRatio(context),
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
                      tabs: <Widget>[
                        Tab(
                            text:
                                '사용가능 ${widget.couponInfo.couponStateCount.enabledCount}'),
                        Tab(
                            text:
                                '사용완료/만료 ${widget.couponInfo.couponStateCount.disabledCount}'),
                      ],
                    ),
                  ),
                ])),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: <Widget>[
                _buildCouponList(
                    context, widget.couponInfo.couponList, 'SAVED'),
                _buildCouponList(
                    context, widget.couponInfo.couponList, 'USAGED'),
              ],
            )));
  }
}
