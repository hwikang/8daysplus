import 'dart:io';

import 'package:core/core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../../utils/device_ratio.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';
import '../components/common/dialog_widget.dart';
import '../components/common/notification_popup_widget.dart';
import 'discovery_page.dart';
import 'main_page.dart';
import 'my_page.dart';
import 'reservation_page.dart';

class NavigatePage extends StatelessWidget {
  const NavigatePage({@required this.event});

  final NavbarEvent event;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const MainPage(key: PageStorageKey<String>('main')),
      const DiscoveryPage(key: PageStorageKey<String>('search')),
      const ReservationPage(key: PageStorageKey<String>('reservation')),
      const MyPage(key: PageStorageKey<String>('my')),
    ];

    return MultiProvider(providers: <SingleChildCloneableWidget>[
      Provider<NavbarBloc>(
          create: (context) => NavbarBloc(initialEvent: event)),
      Provider<RefreshPagesBloc>(create: (context) => RefreshPagesBloc()),
    ], child: _BuildPage(event: event, pages: pages));
  }
}

class _BuildPage extends StatefulWidget {
  const _BuildPage({@required this.event, @required this.pages});

  final NavbarEvent event;
  final List<Widget> pages;

  @override
  __BuildPageState createState() => __BuildPageState();
}

class __BuildPageState extends State<_BuildPage> {
  int currentIndex;
  CupertinoTabController tabController = CupertinoTabController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // String _messageText;

  @override
  void initState() {
    super.initState();
    switch (widget.event) {
      case NavbarEvent.Main:
        currentIndex = 0;
        break;
      case NavbarEvent.Search:
        currentIndex = 1;
        break;
      case NavbarEvent.Reservation:
        currentIndex = 2;
        break;
      case NavbarEvent.My:
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }
    firebaseConfig();
    // _messageText = 'Waiting for message...';
  }

  void firebaseConfig() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        // 앱이 실행중일 경우
        print('onMessage');
        print(message);

        var title = '';
        var body = '';

        if (Platform.isIOS) {
          title = message['aps']['alert']['title'];
          body = message['aps']['alert']['body'];
        } else {
          if (message.containsKey('notification')) {
            // Handle notification message
            final dynamic notification = message['notification'];

            title = notification['title'];
            body = notification['body'];
          }
        }
        // _messageText = 'Push Messaging message: $message';
        final overlayState = Overlay.of(context);
        final overlayEntry = OverlayEntry(builder: (context) {
          return Positioned(
              top: 40.0,
              right: 10.0,
              child: NotificationPopupWidget(title: title, body: body));
        });
        overlayState.insert(overlayEntry);
        Future<void>.delayed(const Duration(milliseconds: 1000), () {
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
          );
        });

        Future<void>.delayed(const Duration(milliseconds: 4400), () {
          overlayEntry.remove();
          print('removed ');
        });

        print('onMessage: $message');
        // return;
      },
      // 앱이 완전히 종료된 경우
      onLaunch: (message) async {
        print('onLaunch');
        if (Platform.isIOS) {
          if (message['key'] == 'web') {
           AppRoutes.buildTitledModalBottomSheet(
                context: context,
                title: message['aps']['alert']['title'],
                child: WebviewScaffold(
                  url: message['message'],
                ));
          } else if (message['key'] == 'order') {
            // ordercode
            AppRoutes.notiMyOrderDetailPage(context, message['message']);
          } else if (message['key'] == 'detail') {
            AppRoutes.productDetailSimplePage(
                context: context,
                productId: message['productId'],
                productType: message['productType'],
                title: message['title']);
          }
        } else {
          if (message['data']['key'] == 'web') {
            final dynamic notification = message['notification'];
            AppRoutes.buildTitledModalBottomSheet(
                context: context,
                title: notification['title'],
                child: WebviewScaffold(
                  url: message['data']['message'],
                ));
          } else if (message['data']['key'] == 'order') {
            // ordercode
            AppRoutes.notiMyOrderDetailPage(
                context, message['data']['message']);
          } else if (message['data']['key'] == 'detail') {
            AppRoutes.productDetailSimplePage(
                context: context,
                productId: message['data']['productId'],
                productType: message['data']['productType'],
                title: message['data']['title']);
          }
        }

        print('onLaunch: $message');
        return;
      },
      // 앱이 닫혀있었으나 백그라운드로 동작중인 경우
      onResume: (message) async {
        if (Platform.isIOS) {
          if (message['key'] == 'web') {
            AppRoutes.buildTitledModalBottomSheet(
                context: context,
                title: message['aps']['alert']['title'],
                child: WebviewScaffold(
                  url: message['message'],
                ));
          } else if (message['key'] == 'order') {
            // ordercode
            AppRoutes.notiMyOrderDetailPage(context, message['message']);
          } else if (message['key'] == 'detail') {
            AppRoutes.productDetailSimplePage(
                context: context,
                productId: message['productId'],
                productType: message['productType'],
                title: message['title']);
          }
        } else {
          if (message['data']['key'] == 'web') {
            final dynamic notification = message['notification'];
            AppRoutes.buildTitledModalBottomSheet(
                context: context,
                title: notification['title'],
                child: WebviewScaffold(
                  url: message['data']['message'],
                ));
          } else if (message['data']['key'] == 'order') {
            AppRoutes.notiMyOrderDetailPage(
                context, message['data']['message']);
          } else if (message['data']['key'] == 'detail') {
            AppRoutes.productDetailSimplePage(
                context: context,
                productId: message['data']['productId'],
                productType: message['data']['productType'],
                title: message['data']['title']);
          }
        }
        print('onResume: $message');
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NavbarBloc>(context);
    final pageController =
        PageController(keepPage: true, initialPage: currentIndex);

    return WillPopScope(
        onWillPop: () {
          DialogWidget.buildTwoButtonDialog(
              context: context,
              title: NavigagePageStrings.navAppCloseTitle,
              subTitle1: NavigagePageStrings.navAppCloseSubTitle,
              buttonTitle1: CommonTexts.no,
              buttonTitle2: CommonTexts.yes,
              onPressed2: () {
                print('pop');
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  exit(0);
                }
                return true;
              });
          return Future<bool>.value(false);
        },
        child: Scaffold(
          bottomNavigationBar: Container(
            child: BottomNavigationBar(
              showUnselectedLabels: false,
              showSelectedLabels: false,
              // elevation: 1.0,
              selectedFontSize: 0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                pageController.jumpToPage(currentIndex);
              },
              currentIndex: currentIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  title: const Text('Main'), //required parameter
                  activeIcon: GestureDetector(
                    onDoubleTap: () {
                      bloc.mainDoubleTap(context);
                    },
                    child: Image(
                      image: AssetImage(ImageAssets.bottomNavMainClick),
                      width: 48 * DeviceRatio.scaleWidth(context),
                    ),
                  ),
                  icon: Image(
                    image: AssetImage(ImageAssets.bottomNavMain),
                    width: 48 * DeviceRatio.scaleWidth(context),
                  ),
                ),
                BottomNavigationBarItem(
                  title: const Text('Discovery'),
                  activeIcon: GestureDetector(
                    onDoubleTap: bloc.discoveryDoubleTap,
                    child: Image(
                      image: AssetImage(ImageAssets.bottomNavDiscoveryClick),
                      width: 48 * DeviceRatio.scaleWidth(context),
                    ),
                  ),
                  icon: Image(
                    image: AssetImage(ImageAssets.bottomNavDiscovery),
                    width: 48 * DeviceRatio.scaleWidth(context),
                  ),
                ),
                BottomNavigationBarItem(
                  title: const Text('Reservation'),
                  activeIcon: GestureDetector(
                    onDoubleTap: bloc.reservationDoubleTap,
                    child: Image(
                      image: AssetImage(ImageAssets.bottomNavReservationClick),
                      width: 48 * DeviceRatio.scaleWidth(context),
                    ),
                  ),
                  icon: Image(
                    image: AssetImage(ImageAssets.bottomNavReservation),
                    width: 48 * DeviceRatio.scaleWidth(context),
                  ),
                ),
                BottomNavigationBarItem(
                  title: const Text('My'),
                  activeIcon: GestureDetector(
                    onDoubleTap: bloc.myDoubleTap,
                    child: Image(
                      image: AssetImage(ImageAssets.bottomNavMyClick),
                      width: 48 * DeviceRatio.scaleWidth(context),
                    ),
                  ),
                  icon: Image(
                    image: AssetImage(ImageAssets.bottomNavMy),
                    width: 48 * DeviceRatio.scaleWidth(context),
                  ),
                ),
              ],
            ),
          ),
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: widget.pages,
          ),
        ));
  }
}
