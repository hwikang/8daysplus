import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';

class SearchFilterBloc {
  SearchFilterBloc({this.model}) {
    filterController.add(model);
  }

  final BehaviorSubject<SearchFilterModel> filterController =
      BehaviorSubject<SearchFilterModel>();

  SearchFilterModel model;

  final BehaviorSubject<String> _activityController = BehaviorSubject<String>();
  final BehaviorSubject<String> _locationController = BehaviorSubject<String>();
  final BehaviorSubject<MoneyFilterModel> _moneyController =
      BehaviorSubject<MoneyFilterModel>();

  final BehaviorSubject<SortFilterModel> _sortController =
      BehaviorSubject<SortFilterModel>();

  // Observable<SortFilterModel> get sortFilter => _sortController.stream;

  // Observable<MoneyFilterModel> get moneyFilter => _moneyController.stream;

  // Observable<String> get locationFilter => _locationController.stream;

  // Observable<String> get activityFilter => _activityController.stream;

  void changeSortFilter(SortFilterModel sort) {
    _sortController.add(sort);
    model.sort = sort;
    filterController.add(model);
  }

  void changeMoneyFilter(MoneyFilterModel filterModel) {
    _moneyController.add(filterModel);
    model.money = filterModel;
    filterController.add(model);
  }

  void changeLocationFilter(CategoryModel location) {
    _locationController.add(location.name);
    model.location = CategoryModel(id: location.id, name: location.name);
    filterController.add(model);
  }

  void changeTypeFilter(CategoryModel type) {
    _activityController.add(type.name);
    model.type = CategoryModel(id: type.id, name: type.name);
    filterController.add(model);
  }

  void clearBasicFilter() {
    _sortController.add(const SortFilterModel());
    _moneyController.add(const MoneyFilterModel());
    model.sort = const SortFilterModel();
    model.money = const MoneyFilterModel();
    filterController.add(model);
  }

  SearchFilterModel getFilterModel() {
    return filterController.value;
  }

  Stream<SearchFilterModel> get filterList => filterController.stream;

  void dispose() {
    filterController.close();
    _sortController.close();
    _moneyController.close();
    _locationController.close();
    _activityController.close();
  }
}
