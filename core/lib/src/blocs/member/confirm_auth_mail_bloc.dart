// import 'dart:js';

import '../../../core.dart';

class ConfirmEmailBloc {
  ConfirmEmailBloc();

  ConfirmAuthMailProvider confirmAuthMailProvider = ConfirmAuthMailProvider();

  // final BehaviorSubject<String> _confirmAuthMailController =
  //     BehaviorSubject<String>();

  // // Observable<String> get confirmAuthMailStream => _confirmAuthMailController.stream;

  // void dispose() {
  //   _confirmAuthMailController.close();
  // }

  Future<bool> confirmAuthMail(String email, String userType) {
    // bool retVal = false;

    email = email.trim();

    final model = ConfirmEmailModel(
      email: email,
      userType: userType,
    );

    // verifyEmailProvider.verifyEmail(model);

    return confirmAuthMailProvider.confirmAuthMail(model).then((result) {
      return result;
    }).catchError((exception) => {
          ExceptionHandler.handleError(
            exception,
          )
        });

    // return retVal;
  }
}
