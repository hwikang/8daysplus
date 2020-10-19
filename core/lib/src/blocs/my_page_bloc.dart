import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../core.dart';
import '../models/my_page_model.dart';
import '../providers/my_page_provider.dart';
import '../states/network_state.dart';

class MyPageBloc {
  MyPageBloc() {
    getUserData();
  }

  BehaviorSubject<CouponModel> couponInfo = BehaviorSubject<CouponModel>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  BehaviorSubject<LifePointModel> pointInfo = BehaviorSubject<LifePointModel>();
  BehaviorSubject<bool> recommendStyleAnalysisUse = BehaviorSubject<bool>();
  BehaviorSubject<UserModel> userInfo = BehaviorSubject<UserModel>();

  final MyPageProvider _myPageProvider = MyPageProvider();

  void getUserData() {
    networkState.add(NetworkState.Start);
    userConnection().then((data) {
      if (data != null) {
        pointInfo.add(data['lifePoint']);
        userInfo.add(data['user']);
        couponInfo.add(data['coupon']);
        recommendStyleAnalysisUse.add(data['recommendStyleAnalysisUse']);
        networkState.add(NetworkState.Normal);
      }
    });
  }

  void changePageState(NetworkState state) {
    networkState.add(state);
  }

  Future<void> fetch() {
    networkState.add(NetworkState.Start);
    return userConnection().then((data) {
      if (data != null) {
        networkState.add(NetworkState.Normal);
        pointInfo.add(data['lifePoint']);
        userInfo.add(data['user']);
        couponInfo.add(data['coupon']);
      }
    });
  }

  Future<Map<String, dynamic>> userConnection() {
    return _myPageProvider.userConnection(isFetch: true)
        //   .timeout(const Duration(milliseconds: 10000), onTimeout: () {
        // throw TimeoutException('time out in may page bloc');
        // })
        .catchError((exception) {
      print('catch error  $exception');
      ExceptionHandler.handleError(exception,
          networkState: networkState, retry: fetch);
    });
  }
}
