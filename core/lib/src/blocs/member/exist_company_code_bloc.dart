import '../../../core.dart';

class ExistCompanyCodeBloc {
  final existCompanyCodeProvider = ExistCompanyCodeProvider();

  Future<bool> existCompanyCode(String corpCode) {
    return existCompanyCodeProvider.existCompanyCode(corpCode).then((value) {
      return value;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
