import '../../../core.dart';

class CreateRefundBloc {
  final createRefundProvider = CreateRefundProvider();

  Future<bool> createRefund(CreateRefundModel model) {
    return createRefundProvider
        .createOrderRefundRequest(model)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
