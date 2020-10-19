import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/discovery/basic_search_filter_model.dart';
import '../../providers/discovery/basic_search_filter_provider.dart';

class BasicSearchFilterBloc {
  BasicSearchFilterBloc({this.productType}) {
    fetch(productType);
  }

  final BehaviorSubject<BasicSearchFilterModel> basicFilter =
      BehaviorSubject<BasicSearchFilterModel>(); //지역, 엑티비티

  final String productType;
  final BasicSearchFilterProvider searchFilterProvider =
      BasicSearchFilterProvider();

  void fetch(String productType) {
    getSearchFilter(productType)
        .then(basicFilter.add)
        .catchError((error) => {basicFilter.addError(error)});
  }

  Future<BasicSearchFilterModel> getSearchFilter(String productType) {
    return searchFilterProvider
        .searchFilter(productType: productType)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }
}
