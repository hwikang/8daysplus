import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/reservation/order_list_model.dart';
import '../../providers/order/order_detail_provider.dart';

class OrderDetailBloc {
  OrderDetailBloc({this.orderCode}) {
    fetch();
  }

  String orderCode;
  final BehaviorSubject<OrderListViewModel> orderDetail =
      BehaviorSubject<OrderListViewModel>();

  OrderDetailProvider orderDetailProvider = OrderDetailProvider();

  void fetch() {
    getOrderDetail(orderCode)
        .then(orderDetail.add)
        .catchError(orderDetail.addError);
  }

  Future<OrderListViewModel> getOrderDetail(String orderCode) {
    return orderDetailProvider
        .order(orderCode)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
