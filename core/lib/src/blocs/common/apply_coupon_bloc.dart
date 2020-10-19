import '../../../core.dart';

class ApplyCouponBloc {
  final ApplyCouponProvider couponProvider = ApplyCouponProvider();

  Future<ApplyCouponModel> getCoupon(String id) {
    return couponProvider
        .applyCoupon(id)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
