import 'package:core/core.dart';

class AddCartBloc {
  final addCartProvider = AddCartProvider();

  void add() {}

  Future addCart(OrderInfoProductModel product) {
    return addCartProvider
        .addCart(product)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
