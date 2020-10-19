import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../ui/components/common/dialog_widget.dart';
import '../ui/components/common/loading_widget.dart';
import '../ui/components/common/network_delay_widget.dart';
import '../ui/pages/member/member_main_page.dart';
import 'strings.dart';

class HandleNetworkError {
  static Widget handleNetwork(
      {@required NetworkState state,
      Function retry,
      @required Widget child,
      BuildContext context,
      bool preventStartState = false}) {
    switch (state) {
      case NetworkState.Start:
      case NetworkState.Changing:
        if (preventStartState) {
          return child;
        }
        return const LoadingWidget();
        break;
      case NetworkState.LoginError:
        return MemberMainPage();
        break;
      case NetworkState.NetworkError:
        print('state $state');
        return NetworkDelayWidget(
          retry: retry,
        );
      case NetworkState.Failed:
        return NetworkDelayPage(
          retry: retry,
        );
        break;
      default:
        return child;
    }
  }

  static void showErrorDialog(BuildContext context, dynamic error) {
    if (error.contains('error_msg')) {
      final Map<String, dynamic> map = json.decode(error);

      DialogWidget.buildDialog(
        context: context,
        title: ErrorTexts.error,
        subTitle1: map['error_msg'],
      );
    } else {
      DialogWidget.buildDialog(
        context: context,
        subTitle1: '$error',
        title: ErrorTexts.error,
      );
    }
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    if (error.contains('error_msg')) {
      final Map<String, dynamic> map = json.decode(error);

      DialogWidget.showAlert(context: context, child: Text(map['error_msg']));
    } else {
      DialogWidget.showAlert(context: context, child: Text(error));
    }
  }
}
