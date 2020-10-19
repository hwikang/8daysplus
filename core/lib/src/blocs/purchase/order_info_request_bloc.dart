import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../providers/purchase/order_info_request_provider.dart';

class OrderInfoRequestBloc {
  // OrderInfoRequestBloc({this.orderInputList}) {
  //will not fetch on cart list ,
  // if (orderInputList != null) {
  //   fetch();
  // }
  // }

  OrderInfoRequestProvider orderInfoRequestProvider =
      OrderInfoRequestProvider();

  // final List<OrderInfoProductModel> orderInputList;
  final BehaviorSubject<CreateOrderInputModel> repoData =
      BehaviorSubject<CreateOrderInputModel>();

  // void fetch() {
  //   orderInfoRequest(orderInputList)
  //       .then(repoData.add)
  //       .catchError(repoData.addError);
  // }

  Future<CreateOrderInputModel> orderInfoRequest(
      List<OrderInfoProductModel> orderInputList) {
    assert(orderInputList != null);
    return orderInfoRequestProvider
        .orderInfoRequest(orderInputList)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void dispose() {
    repoData.close();
  }
}
