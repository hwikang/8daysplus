import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/firebase_analytics.dart';
import '../../utils/get_location.dart';
import '../../utils/handle_network_error.dart';
import '../../utils/one_signal_client.dart';
import '../../utils/routes.dart';
import '../../utils/singleton.dart';
import '../../utils/strings.dart';
import '../components/common/dialog_widget.dart';
import '../components/common/expandable_powered_bottom_widget.dart';
import '../components/common/loading_widget.dart';
import '../components/main/feed_banner_widget.dart';
import '../components/main/feed_bigslide_product_widget.dart';
import '../components/main/feed_card_view_widget.dart';
import '../components/main/feed_coupon_widget.dart';
import '../components/main/feed_grid_group_product_widget.dart';
import '../components/main/feed_grid_product_widget.dart';
import '../components/main/feed_list_map_widget.dart';
import '../components/main/feed_list_view_widget.dart';
import '../components/main/feed_promotion_widget.dart';
import '../components/main/feed_slide_product_widget.dart';
import '../components/main/feed_small_banner_widget.dart';
import '../components/main/feed_small_slide_product_widget.dart';
import '../components/main/main_appbar_widget.dart';
import '../modules/common/handle_network_module.dart';
import 'product_detail_simple_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<MainPageBloc>(
        create: (context) => MainPageBloc(
            first: 20,
            lat: Singleton.instance.curLat,
            lng: Singleton.instance.curLng),
        dispose: (context, bloc) {
          print('main dispose');
          bloc.dispose();
        },
        child: MainPageModule());
  }
}

class MainPageModule extends StatefulWidget {
  @override
  _MainPageModuleState createState() => _MainPageModuleState();
}

class _MainPageModuleState extends State<MainPageModule>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<MainPageModule> {
  bool isDialogOpened;

  ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<MainPageBloc>(context);
    final navBloc = Provider.of<NavbarBloc>(context);
    _scrollController = navBloc.mainPageScrollController;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (bloc.networkState.value == NetworkState.Normal) {
          bloc.getMoreFeed();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    isDialogOpened = false;
    fetchLinkData();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    //Remove this method to stop OneSignal Debugging
    OneSignalClient.instance.initialize(context).then((_) {
      AppRoutes.authCheck(context).then((value) async {
        if (value) {
          final prefs = await SharedPreferences.getInstance();
          getLogger(this).d('sending OneSignal Tags');

          OneSignalClient.instance.sendTag(UserPropertyStrings.email,
              prefs.getString(UserPropertyStrings.email));
          OneSignalClient.instance.sendTag(UserPropertyStrings.companyCode,
              prefs.getString(UserPropertyStrings.companyCode));
          OneSignalClient.instance.sendTag(UserPropertyStrings.marketingAgree,
              prefs.getString(UserPropertyStrings.marketingAgree));
          OneSignalClient.instance.sendTag(UserPropertyStrings.appVersion,
              prefs.getString(UserPropertyStrings.appVersion));
          OneSignalClient.instance.sendTag(UserPropertyStrings.signUpType,
              prefs.getString(UserPropertyStrings.signUpType));
          OneSignalClient.instance.sendTag(UserPropertyStrings.birthDay,
              prefs.getString(UserPropertyStrings.birthDay));

          Crashlytics.instance
              .setUserEmail(prefs.getString(UserPropertyStrings.email));
        } else {
          getLogger(this).d('deleting OneSignal Tags');

          OneSignalClient.instance.deleteTag(UserPropertyStrings.email);
          OneSignalClient.instance.deleteTag(UserPropertyStrings.companyCode);
          OneSignalClient.instance
              .deleteTag(UserPropertyStrings.marketingAgree);
          OneSignalClient.instance.deleteTag(UserPropertyStrings.appVersion);
          OneSignalClient.instance.deleteTag(UserPropertyStrings.signUpType);
          OneSignalClient.instance.deleteTag(UserPropertyStrings.birthDay);
        }
      });
    });
  }

  Future<void> _processDynamicLink(Uri link) async {
    if (link != null) {
      final logger = getLogger(this);
      logger.d('[DynamicLink] Processing dynamic-link: $link');
      if (!link.hasEmptyPath) {
        final array = link.path.split('/');
        if (array.length > 2) {
          final value = array[2];
          switch (array[1].toLowerCase()) {
            case 'productid':
              AppRoutes.push(
                  context,
                  ProductDetailSimplePage(
                    productId: value,
                  ));
              break;
            case 'promotionid':
              AppRoutes.noticeEventDetailPage(
                context,
                value,
              );
              break;
            case 'route':
              Navigator.pushNamed(context, value);
              break;
          }
        }
      }
    }
  }

  Future<void> fetchLinkData() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      await _processDynamicLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      getLogger(this).d('[DynamicLink] onLink: $dynamicLink');
      await _processDynamicLink(dynamicLink?.link);
    }, onError: (e) async {
      getLogger(this).e(e);
    });
  }

  Future<bool> fetch() {
    final mainPageBloc = Provider.of<MainPageBloc>(context);
    return mainPageBloc.fetch();
  }

  Future<void> showUpdatePopup(BuildContext context) async {
    assert(Singleton.instance.versionModel != null);
    //빌드후실행
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Singleton.instance.versionModel.isForceUpdate) {
        DialogWidget.buildDialog(
          context: context,
          title: Singleton.instance.versionModel.comment,
          subTitle1: MainPageStrings.forceUpdateTitle,
          buttonTitle: MainPageStrings.updateTrue,
          onPressed: launchURL,
        );
        prefs.setString('LASTUPDATEPOPTIME', now.toString());
      } else if (Singleton.instance.versionModel.isUpdate) {
        getUpdateTimeCheck().then((show) {
          if (show) {
            DialogWidget.buildTwoButtonDialog(
                context: context,
                title: Singleton.instance.versionModel.comment,
                subTitle1: MainPageStrings.updateTitle,
                buttonTitle1: MainPageStrings.updateTrue,
                onPressed1: launchURL,
                buttonTitle2: MainPageStrings.updateFalse,
                onPressed2: () {
                  prefs.setString('LASTUPDATEPOPTIME', now.toString());
                  Navigator.pop(context);
                });
          }
        });
      }
    });
  }

  Future<bool> getUpdateTimeCheck() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    print('@@LASTUPDATEPOPTIME ${prefs.getString('LASTUPDATEPOPTIME')}');
    if (prefs.containsKey('LASTUPDATEPOPTIME') &&
        prefs.getString('LASTUPDATEPOPTIME') != '') {
      final lastUpdatePopTime = prefs.getString('LASTUPDATEPOPTIME');

      final lastUpdateTime = DateTime.parse(lastUpdatePopTime);
      print('lastUpdateTime $lastUpdateTime');
      final difference = now.difference(lastUpdateTime).inHours;
      print('difference $difference');

      if (difference > 24) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  void launchURL() {
    Navigator.of(context).pop();
    launch(Singleton.instance.versionModel.downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //need this to block refresh page
    showUpdatePopup(context);

    final mainPageBloc = Provider.of<MainPageBloc>(context);

    Analytics.analyticsScreenName('Main');

    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: MainAppbarWidget(showCartIcon: Singleton.instance.isLogin),
            ),
            body: StreamBuilder<NetworkState>(
              stream: Provider.of<MainPageBloc>(context).networkState,
              initialData: NetworkState.Start,
              builder: (context, mainStateSnapshot) {
                return HandleNetworkError.handleNetwork(
                    state: mainStateSnapshot.data,
                    retry: () {
                      mainPageBloc.networkState.add(NetworkState.Start);
                      return fetch();
                    },
                    context: context,
                    child: StreamBuilder<List<FeedModel>>(
                        stream: Provider.of<MainPageBloc>(context).repoList,
                        builder: (context, listSnapshot) {
                          if (!listSnapshot.hasData) {
                            return Container();
                          }
                          return RefreshIndicator(
                            onRefresh: () {
                              mainPageBloc.networkState.add(NetworkState.Retry);
                              return fetch();
                            },
                            backgroundColor: Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              itemCount: listSnapshot.data.length +
                                  1 +
                                  1, // copyright 추가로 +1더함.
                              itemBuilder: (context, index) {
                                if (index ==
                                    mainPageBloc.repoList.value.length) {
                                  if (mainStateSnapshot.data !=
                                      NetworkState.Finish) {
                                    return const Center(
                                        heightFactor: 3,
                                        child: LoadingWidget());
                                  }
                                  return Container();
                                } else if (index ==
                                    mainPageBloc.repoList.value.length + 1) {
                                  return ExpandablePoweredBottomWidget();
                                } else {
                                  // print(
                                  //     '$index ${mainPageBloc.repoList.value[index].node['__typename']}');
                                  switch (mainPageBloc.repoList.value[index]
                                      .node['__typename']) {
                                    case 'FeedPromotions':
                                      return FeedPromotionWidget(
                                          list: mainPageBloc
                                              .repoList
                                              .value[index]
                                              .node['feedPromotions'],
                                          title: mainPageBloc.repoList
                                              .value[index].node['title']);
                                      break;

                                    case 'FeedGridProducts':
                                      return FeedGridProductWidget(
                                        node: listSnapshot.data[index].node,
                                        stream:
                                            Provider.of<MainPageBloc>(context)
                                                .networkState,
                                      );
                                      break;
                                    case 'FeedGridGroupProducts':
                                      return FeedGridGroupProductWidget(
                                        node: mainPageBloc
                                            .repoList.value[index].node,
                                      );
                                      break;
                                    case 'FeedSmallSlideProducts':
                                      return FeedSmallSlideProductWidget(
                                        node: mainPageBloc
                                            .repoList.value[index].node,
                                      );
                                      break;
                                    case 'FeedSmallBanners':
                                      return FeedSmallBannerWidget(
                                        bannerList: mainPageBloc
                                            .repoList
                                            .value[index]
                                            .node['feedSmallBanners'],
                                      );
                                      break;
                                    case 'FeedBanners':
                                      return FeedBannerWidget(
                                        bannerList: mainPageBloc.repoList
                                            .value[index].node['feedBanners'],
                                      );
                                      break;
                                    case 'FeedSlideProducts':
                                      return FeedSlideProductWidget(
                                        title: mainPageBloc.repoList
                                            .value[index].node['title'],
                                        productList: mainPageBloc
                                            .repoList
                                            .value[index]
                                            .node['feedSlideProducts'],
                                      );
                                      break;

                                    case 'FeedBigSlideProducts':
                                      return FeedBigSlideProductWidget(
                                        node: mainPageBloc
                                            .repoList.value[index].node,
                                      );
                                      break;
                                    case 'FeedListViewMapProducts':
                                      return FeedListMapWidget(
                                          node: mainPageBloc
                                              .repoList.value[index].node);
                                      break;
                                    case 'FeedListViewProducts': //
                                      return FeedListViewWidget(
                                        title: mainPageBloc.repoList
                                            .value[index].node['title'],
                                        productList: mainPageBloc
                                            .repoList
                                            .value[index]
                                            .node['feedListViewProducts'],
                                      );
                                      break;
                                    case 'FeedCoupons':
                                      return FeedCouponWidget(
                                        title: mainPageBloc.repoList
                                            .value[index].node['title'],
                                        couponList: mainPageBloc.repoList
                                            .value[index].node['feedCoupons'],
                                      );
                                      break;
                                    case 'FeedCardProducts': //
                                      return FeedCardViewWidget(
                                        title: mainPageBloc.repoList
                                            .value[index].node['title'],
                                        productList: mainPageBloc
                                            .repoList
                                            .value[index]
                                            .node['feedCardProducts'],
                                      );
                                      break;
                                    default:
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                      );
                                      break;
                                  }
                                }
                              },
                            ),
                          );
                        }));
              },
            )));
  }
}
