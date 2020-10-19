import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../providers/member/temp_password_provider.dart';

class TempPasswordBloc {
  final TempPasswordProvider tempPasswordProvider = TempPasswordProvider();

  final BehaviorSubject<String> emailController = BehaviorSubject<String>();

  Function(String) get changeEmail => emailController.add;

  String getEmail() {
    return emailController.value;
  }

  Future<bool> submit() {
    final validEmail = emailController.value;

    final input = FindPasswordInput(
      email: validEmail,
      userType: 'EMPLOYEE',
    );

    return findPassword(input).then((_) {
      return true;
    });
  }

  Future<void> findPassword(FindPasswordInput input) {
    return tempPasswordProvider.findPassword(input).catchError((exception) {
      print('catch error $exception');
      ExceptionHandler.handleError(
        exception,
      );
    });
  }

  void dispose() {
    emailController.close();
  }
}
