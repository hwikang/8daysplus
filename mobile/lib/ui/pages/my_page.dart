import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../../utils/device_ratio.dart';
import '../../utils/firebase_analytics.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';
import '../../utils/text_styles.dart';
import '../components/common/customer_center_widget.dart';
import '../components/common/loading_widget.dart';
import '../components/my/mypage_main_list.dart';
import '../modules/common/handle_network_module.dart';
import 'member/member_main_page.dart';
import 'mypage/account/account_manage_page.dart';
import 'mypage/my_point_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Widget page = Container(
    height: 0.0,
  );

  @override
  void initState() {
    super.initState();
    AppRoutes.authCheck(context).then((isLogin) {
      setState(() {
        if (isLogin) {
          page = Provider<MyPageBloc>(
            create: (context) => MyPageBloc(),
            child: MyMainPage(),
          );
        } else {
          page = SafeArea(child: MemberMainPage());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      return page;
    } else {
      return Container();
    }
  }
}

class MyMainPage extends StatelessWidget {
  Widget _recommendStyleAnalysis(
    BuildContext context,
  ) {
    return StreamBuilder<bool>(
      stream: Provider.of<MyPageBloc>(context).recommendStyleAnalysisUse,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Container(
              margin: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
              ),
              child: StyleAnalyzeBanner());
        }
        return Container();
      },
    );
  }

  Widget _buildPointContainer(BuildContext context, UserModel userInfo) {
    final formatter = NumberFormat('#,###');

    final myPageBloc = Provider.of<MyPageBloc>(context);
    return Container(
      height: 57 * DeviceRatio.scaleRatio(context) + 48,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(builder: (context) {
                  final lifePointModel = myPageBloc.pointInfo.value;
                  return MyPointPage(lifePointModel: lifePointModel);
                }));
              },
              child: Container(
                decoration: const BoxDecoration(
                    border:
                        Border(right: BorderSide(color: Color(0xffeeeeee)))),
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        MyPageStrings.myPoint,
                        style: TextStyles.black14BoldTextStyle,
                      ),
                      Text(
                        '${formatter.format(myPageBloc.pointInfo.value.lifePoint)}P',
                        style: TextStyles.black22BoldTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppRoutes.myCouponPage(context, myPageBloc.couponInfo.value);
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      MyPageStrings.myCoupon,
                      style: TextStyles.black14BoldTextStyle,
                    ),
                    Text(
                      '${myPageBloc.couponInfo.value.couponStateCount.enabledCount}',
                      style: TextStyles.black22BoldTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBlackContainer(BuildContext context, UserModel userInfo) {
    final myPageBloc = Provider.of<MyPageBloc>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (context) {
          return AccountManagePage(
            userInfo: userInfo,
            myPageBloc: myPageBloc, //update 에따른 즉각적 변경 위해 필요
          );
        }));
      },
      child: Container(
        height: 80 * MediaQuery.of(context).textScaleFactor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        color: const Color(0xff313537),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                '${userInfo.profile.name}님',
                style: TextStyles.white18BoldTextStyle,
              ),
            ),
            Text(
              MyPageStrings.myAccount,
              style: TextStyles.white12TextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Mypage');

    final navBloc = Provider.of<NavbarBloc>(context);
    final myPageBloc = Provider.of<MyPageBloc>(context);
    final _scrollController = navBloc.myPageScrollController;

    return SafeArea(
        child: StreamBuilder<bool>(
            stream:
                Provider.of<RefreshPagesBloc>(context).refreshMyPageController,
            initialData: false,
            builder: (context, refreshSnapshot) {
              if (refreshSnapshot.data) {
                print('re fetch my page');
                refreshPagesBloc.changeMyPageRefreshState(false);

                myPageBloc.fetch(); // refetch
              }
              return HandleNetworkModule(
                networkState: Provider.of<MyPageBloc>(context).networkState,
                retry: Provider.of<MyPageBloc>(context).fetch,
                preventStartState: true,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          AppRoutes.cartListPage(context);
                        },
                        child: Image.asset(
                          ImageAssets.bagImage,
                          width: 40,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 14),
                        child: GestureDetector(
                          onTap: () {
                            // MyPageSettingPage
                            AppRoutes.mySettingPage(context);
                          },
                          child: Image.asset(
                            ImageAssets.optionImage,
                            width: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                  body: StreamBuilder<UserModel>(
                    stream: Provider.of<MyPageBloc>(context).userInfo,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: LoadingWidget());
                      }
                      return RefreshIndicator(
                          onRefresh: () {
                            return Provider.of<MyPageBloc>(context).fetch();
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: <Widget>[
                                _buildTopBlackContainer(context, snapshot.data),
                                _buildPointContainer(context, snapshot.data),
                                _recommendStyleAnalysis(context),
                                MyPageMainList(
                                  title: MyPageStrings.myShoppingInfo,
                                  listTitle1: MyPageStrings.myOrderList,
                                  listOnTap1: () {
                                    AppRoutes.myOrderPage(context);
                                  },
                                  listTitle2: MyPageStrings.myInquiryList,
                                  listOnTap2: () {
                                    AppRoutes.inquiryListPage(context);
                                  },
                                  actionTitle: '',
                                  actionColor: Colors.grey,
                                ),
                                MyPageMainList(
                                  title: MyPageStrings.myCustomerCenter,
                                  listTitle1: MyPageStrings.myNoticeList,
                                  listOnTap1: () {
                                    AppRoutes.noticeListPage(context);
                                  },
                                  listTitle2: MyPageStrings.myFaq,
                                  listOnTap2: () {
                                    AppRoutes.faqPage(context);
                                  },
                                  actionTitle: '',
                                  actionColor: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        MyPageStrings.myCustomerCenterGuide,
                                        style: TextStyles.black14TextStyle,
                                      ),
                                      CustomerCenterWidget(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
                ),
              );
            }));
  }
}

class StyleAnalyzeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.myStylePage(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffeeeeee), width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    MyPageStrings.myStyle,
                    style: TextStyles.black14BoldTextStyle,
                  ),
                  Text(
                    MyPageStrings.myStyleGuide,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.black12TextStyle,
                  ),
                ],
              ),
            ),
            Container(
                // padding: EdgeInsets.only(left:26),
                child: Image.asset(
              ImageAssets.analyzeImage,
              width: 50,
            ))
          ],
        ),
      ),
    );
  }
}
