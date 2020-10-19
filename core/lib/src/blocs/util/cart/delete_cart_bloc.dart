import '../../../../core.dart';

class DeleteCartBloc {
  final deleteCartProvider = DeleteCartProvider();

  Future<bool> deleteCart(List<String> ids) {
    return deleteCartProvider
        .deleteCart(ids)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
