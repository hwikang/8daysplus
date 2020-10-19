import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../../core.dart';
import '../../../utils/network_error_handler.dart';

class MyStylePageBloc {
  MyStylePageBloc() {
    repoList.add(<FeedModel>[]);
    fetch();
  }

  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  RecommendAnalysisProvider recommendAnalysisProvider =
      RecommendAnalysisProvider();

  final BehaviorSubject<List<FeedModel>> repoList =
      BehaviorSubject<List<FeedModel>>();

  Future<bool> fetch() {
    return getRecommendAnalysis().then((dynamic data) {
      if (data != null) {
        repoList.add(data);
        networkState.add(NetworkState.Normal);
        return true;
      }
      return false;
    });
  }

  Future<List<FeedModel>> getRecommendAnalysis() {
    return recommendAnalysisProvider
        .recommendAnalysis()
        .timeout(const Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException('time out in my style bloc');
    }).catchError((dynamic err) {
      print('catch error frmm my style page bloc $err');
      NetworkErrorHandler.handleError(
          err: err,
          onNetworkError: () {
            networkState.add(NetworkState.NetworkError);
          },
          onLoginError: () {
            networkState.add(NetworkState.LoginError);
          },
          defaultError: () {
            networkState.add(NetworkState.Failed);
          });
    });
  }

  void dispose() {
    repoList.close();
    networkState.close();
  }
}
