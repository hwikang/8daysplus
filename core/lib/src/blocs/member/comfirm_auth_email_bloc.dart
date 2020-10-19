import 'dart:async';

import '../../../core.dart';

class ConfirmAuthEmailBloc {
  ConfirmAuthEmailProvider confirmAuthEmailSMSProvider =
      ConfirmAuthEmailProvider();

  Future<String> confirmAuthEmail(
      String countryCode, String mobileNum, String verifyCode) {
    final model = ConfirmAuthSmsModel(
        countryCode: countryCode, mobile: mobileNum, verifyCode: verifyCode);

    return confirmAuthEmailSMSProvider.confirmAuthEmail(model).then((result) {
      print('confirm auth email sms $result');
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
