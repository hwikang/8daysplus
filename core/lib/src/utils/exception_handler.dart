import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:mobile/utils/strings.dart';
import 'package:mobile/utils/refresh_token.dart';

import 'package:rxdart/rxdart.dart';

import '../../core.dart';

class ExceptionHandler {
  static Future<void> handleError(Exception exception,
      {BehaviorSubject networkState, Function retry}) {
    print(' ExceptionHandler $exception');

    if (exception is TimeoutException) {
      logger.w(exception.message);

      print('On TimeoutException');
      if (networkState != null) {
        networkState.add(NetworkState.NetworkError);
      }
      throw exception.message;
    } else if (exception is OperationException) {
      if (exception.graphqlErrors.isEmpty) {
        print('On Client Exception');

        logger.w(exception.clientException.message);
        if (networkState != null) {
          networkState.add(NetworkState.NetworkError);
        }
        throw ErrorTexts.networkError;
      } else {
        // clientException == null
        print('On Graphql Exception');

        logger.w(exception.graphqlErrors[0].message);
        if (exception.graphqlErrors[0].message.contains('error_code') &&
            networkState != null) {
          analyzeErrorAddNetworkState(
              exception.graphqlErrors[0].message, networkState, retry);
        }

        throw exception.graphqlErrors[0].message;
      }
    }
  }

  static void analyzeErrorAddNetworkState(
      String errorMessage, BehaviorSubject networkState, Function retry) {
    final map = json.decode(errorMessage);

    switch (map['error_code']) {
      case 4000:
      case 4005:
      case 4008:
      case 4010:
        //login error
        networkState.add(NetworkState.LoginError);
        break;

      case 4002:
      case 4003:
      case 4009:
        //token error
        print('on Token error');
        Singleton.instance.isLogin = false;

        RefreshToken.refreshToken().then((_) => {retry()}).catchError(() {
          print('catch error on refreshTOken');
          networkState.add(NetworkState.LoginError);
        });
        break;
      default:
        networkState.add(NetworkState.Failed);
    }
  }
}
