import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../providers/member/exist_email_provider.dart';
import '../../utils/exception_handler.dart';

enum ExistEmailEventState { Normal, Logging, Success, Failed }

class ExistEmailBloc {
  ExistsEmailProvider existEmailProvider = ExistsEmailProvider();

  final BehaviorSubject<String> _existEmailController =
      BehaviorSubject<String>();

  // Observable<String> get verifyEmailStream => _existEmailController.stream;

  void dispose() {
    _existEmailController.close();
  }

  Future<Map<String, dynamic>> existEmail(
      String email, String loginType, String codeKey, String corpCode) {
    email = email.trim();

    final model = ExistsEmailModel(
      email: email,
      userType: 'EMPLOYEE',
    );

    return existEmailProvider.existEmail(model, corpCode).then((result) {
      return result;
    }).catchError((exception) => {
          ExceptionHandler.handleError(
            exception,
          )
        });
  }
}
