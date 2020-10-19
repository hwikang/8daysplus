import '../../../core.dart';

class ConfirmMobileBloc {
  ConfirmMobileBloc();

  ConfirmAuthSmsProvider confirmMobileProvider = ConfirmAuthSmsProvider();

  Future<bool> confirmAuthSms(
      String countryCode, String mobileNum, String verifyCode) {
    final model = ConfirmAuthSmsModel(
        countryCode: countryCode, mobile: mobileNum, verifyCode: verifyCode);

    return confirmMobileProvider.confirmAuthSms(model).then((result) {
      print('confirm mobiel $result');
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
