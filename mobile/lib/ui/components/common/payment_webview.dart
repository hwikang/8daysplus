import 'dart:async';
import 'dart:io' show Platform;

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({this.url, this.onFail, this.onSuccess});
  final String url;

  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();

  final Function(Map<String, String>) onSuccess;

  final Function(Map<String, String>) onFail;
}

class _PaymentWebviewState extends State<PaymentWebview> {
  static const platform = MethodChannel('8daysplus.payment');
  static String redirectUrl = 'https://dev-order.the8days.com/api/order/health';
  static String failRedirectUrl = 'https://localhost.fail';

  final FlutterWebviewPlugin webView = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<String> _onUrlChanged;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    webView.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _onUrlChanged = webView.onUrlChanged.listen((url) async {
      print(url);
      if (mounted) {
        if (url.contains(redirectUrl)) {
          Map query = getDataAndCloseWidget(url);
          widget.onSuccess(query);
        } else if (url.startsWith(failRedirectUrl)) {
          Map query = getDataAndCloseWidget(url);
          widget.onFail(query);
          // } else if (isAppLink(url)) {
          //   handleAppLink(url);
        } else {
          //   // return NavigationDecision.navigate;
        }
      }
    });
    _onStateChanged = webView.onStateChanged.listen((state) async {
      final type = state.type;
      final url = state.url;
      print(url);
      if (mounted) {
        // if (type == WebViewState.abortLoad) {
        print('url $url $type');

        if (isAppLink(url)) {
          handleAppLink(url);
          // } else if (url.contains(redirectUrl)) {
          //   Map query = getDataAndCloseWidget(url);
          //   widget.onSuccess(query);
          // } else if (url.startsWith(failRedirectUrl)) {
          //   Map query = getDataAndCloseWidget(url);
          //   widget.onFail(query);
        } else {}

        // }
      }
    });
  }

  Map<String, String> getDataAndCloseWidget(String url) {
    final decodedUrl = Uri.decodeComponent(url);
    final parsedUrl = Uri.parse(decodedUrl);
    final query = parsedUrl.queryParameters;

    Navigator.pop(context);

    return query;
  }

  void handleAppLink(String url) async {
    getAppUrl(url).then((value) async {
      print('value $value');
      if (await canLaunch(value)) {
        await launch(value);
        // return NavigationDecision.prevent;
      } else {
        final marketUrl = await getMarketUrl(url);
        print('market $marketUrl');
        await launch(marketUrl);
      }
    }).catchError((err) {
      logger.i(err);
    });
  }

  Future<String> getAppUrl(String url) async {
    if (Platform.isAndroid) {
      return await platform
          .invokeMethod('getAppUrl', <String, Object>{'url': url});
    } else {
      return url;
    }
  }

  bool isAppLink(String url) {
    final appScheme = Uri.parse(url).scheme;

    return appScheme != 'http' &&
        appScheme != 'https' &&
        appScheme != 'about:blank' &&
        appScheme != 'data';
  }

  Future<String> getMarketUrl(String url) async {
    final appScheme = Uri.parse(url).scheme;
    print(appScheme);
    if (Platform.isIOS) {
      switch (appScheme) {
        case 'kftc-bankpay': // 뱅크페이
          return 'https://itunes.apple.com/kr/app/id398456030';
        case 'ispmobile': // ISP/페이북
          return 'https://itunes.apple.com/kr/app/id369125087';
        case 'hdcardappcardansimclick': // 현대카드 앱카드
          return 'https://itunes.apple.com/kr/app/id702653088';
        case 'shinhan-sr-ansimclick': // 신한 앱카드
          return 'https://itunes.apple.com/app/id572462317';
        case 'kb-acp': // KB국민 앱카드
          return 'https://itunes.apple.com/kr/app/id695436326';
        case 'mpocket.online.ansimclick': // 삼성앱카드
          return 'https://itunes.apple.com/kr/app/id535125356';
        case 'lottesmartpay': // 롯데 모바일결제
          return 'https://itunes.apple.com/kr/app/id668497947';
        case 'lotteappcard': // 롯데 앱카드
          return 'https://itunes.apple.com/kr/app/id688047200';
        case 'cloudpay': // 하나1Q페이(앱카드)
          return 'https://itunes.apple.com/kr/app/id847268987';
        case 'citimobileapp': // 시티은행 앱카드
          return 'https://itunes.apple.com/kr/app/id1179759666';
        case 'payco': // 페이코
          return 'https://itunes.apple.com/kr/app/id924292102';
        case 'kakaotalk': // 카카오톡
          return 'https://itunes.apple.com/kr/app/id362057947';
        case 'lpayapp': // 롯데 L.pay
          return 'https://itunes.apple.com/kr/app/id1036098908';
        case 'wooripay': // 우리페이
          return 'https://itunes.apple.com/kr/app/id1201113419';
        case 'nhallonepayansimclick': // NH농협카드 올원페이(앱카드)
          return 'https://itunes.apple.com/kr/app/id1177889176';
        case 'hanawalletmembers': // 하나카드(하나멤버스 월렛)
          return 'https://itunes.apple.com/kr/app/id1038288833';
        case 'shinsegaeeasypayment': // 신세계 SSGPAY
          return 'https://itunes.apple.com/app/id666237916';
        default:
          return url;
      }
    }
    return await platform
        .invokeMethod('getMarketUrl', <String, Object>{'url': url});
  }

  @override
  Widget build(BuildContext context) {
    print('build payment webview');
    return WebviewScaffold(
      url: widget.url,
      hidden: true,
      ignoreSSLErrors: true,
      invalidUrlRegex: Platform.isAndroid
          ? '^(?!https://|http://|about:blank|data:).+'
          : null,
    );
  }
}
