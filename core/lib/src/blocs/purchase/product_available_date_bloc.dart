import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core.dart';

class ProductAvailableDatesBloc {
  ProductAvailableDatesBloc({
    @required this.productDetailViewModel,
    // @required this.productAvailableDateProvider,
  }) {
    fetch();
  }

  final ProductAvailableDatesProvider productAvailableDateProvider =
      ProductAvailableDatesProvider();
  final ProductDetailViewModel productDetailViewModel;
  final BehaviorSubject<List<ProductAvailableDateModel>> repoList =
      BehaviorSubject<List<ProductAvailableDateModel>>();

  void fetch() {
    productAvailableDates(productDetailViewModel)
        .then(repoList.add)
        .catchError(repoList.addError);
  }

  Future<List<ProductAvailableDateModel>> productAvailableDates(
      ProductDetailViewModel item) {
    return productAvailableDateProvider
        .productAvailableDates(item.id)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void dispose() {
    repoList.close();
  }
}
