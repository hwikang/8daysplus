import '../../../core.dart';

//send auth email for sign up
class AuthEmailBloc {
  AuthEmailBloc();

  AuthEmailProvider authEmailProvider = AuthEmailProvider();

  Future<bool> authEmail(String email) {
    email = email.trim();

    final model = AuthEmailModel(
      email: email,
    );

    return authEmailProvider.authEmail(model).then((result) {
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});

    // return retVal;
  }
}
