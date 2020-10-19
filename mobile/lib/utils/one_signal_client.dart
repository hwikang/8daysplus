import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/components/common/payment_webview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const.dart';
import '../ui/pages/product_detail_simple_page.dart';
import 'routes.dart';

class OneSignalClient {
  static final OneSignalClient instance = OneSignalClient();

  bool isInitialized = false;

  Future<void> initialize(BuildContext context) async {
    isInitialized = true;

    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }

    OneSignal.shared.setRequiresUserPrivacyConsent(false);

    var setting = {
      OSiOSSettings.autoPrompt: true,
      // OSiOSSettings.inAppLaunchUrl: true,
      // OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      var logger = getLogger(this);
      logger.d(openedResult.toString());
      var payload = openedResult.notification.payload;
      var title = payload.additionalData["TITLE"] as String ?? payload.title;
      var inapp = payload.additionalData["INAPP"] as String;
      var ext = payload.additionalData["EXT"] as String ?? payload.launchUrl;
      var promotionId = payload.additionalData["PROMOTIONID"] as String;
      var productId = payload.additionalData["PRODUCTID"] as String;

      print('promotionId $promotionId');
      if (inapp != null && inapp.isNotEmpty) {
        // Launch In-App Browser
        AppRoutes.buildTitledModalBottomSheet(
            context: context, title: title, child: PaymentWebview(url: inapp));
      } else if (ext != null && ext.isNotEmpty && await canLaunch(ext)) {
        await launch(ext);
      } else if (promotionId != null) {
        AppRoutes.noticeEventDetailPage(
          context,
          promotionId,
        );
      } else if (productId != null) {
        AppRoutes.push(context,
            ProductDetailSimplePage(productId: productId, title: title));
      }
    });

    OneSignal.shared.init(ONESIGNAL_APP_ID, iOSSettings: setting);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  void sendTag(String key, String value) {
    if (isInitialized) {
      OneSignal.shared.sendTag(key, value).then(print).catchError(print);
    }
  }

  void deleteTag(String key) {
    if (isInitialized) {
      OneSignal.shared.deleteTag(key);
    }
  }

  void sendTrigger(String key, Object value) {
    if (isInitialized) {
      OneSignal.shared.addTrigger(key, value);
    }
  }
}
