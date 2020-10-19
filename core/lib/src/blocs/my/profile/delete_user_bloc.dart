import 'package:rxdart/subjects.dart';

import '../../../../core.dart';
import '../../../providers/my/point_coupon_count_provider.dart';

class DeleteUserBloc {
  DeleteUserBloc() {
    fetch();
    isAgreed.add(false);
    networkState.add(NetworkState.Start);
  }

  BehaviorSubject<bool> isAgreed = BehaviorSubject<bool>();
  PointCouponCountProvier pointCouponCountProvier = PointCouponCountProvier();
  BehaviorSubject<Map<String, dynamic>> pointCouponState =
      BehaviorSubject<Map<String, dynamic>>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  void toggleAgreeState() {
    isAgreed.add(!isAgreed.value);
  }

  void fetch() {
    getPointCoupon().then((res) {
      pointCouponState.add(res);
      networkState.add(NetworkState.Normal);
    });
  }

  Future<Map<String, dynamic>> getPointCoupon() {
    networkState.add(NetworkState.Loading);
    return pointCouponCountProvier
        .pointCouponCount()
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }

  final deleteUserProvider = DeleteUserProvider();

  Future<bool> deleteUser() {
    return deleteUserProvider.deleteUser().catchError((exception) => {
          ExceptionHandler.handleError(
            exception,
          )
        });
  }
}
