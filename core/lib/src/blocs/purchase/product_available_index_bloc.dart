import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ProductAvailableIndexBloc {
  ProductAvailableIndexBloc({
    this.model,
  }) {
    _indexController.add(model);
  }

  ProductAvailableIndexModel model;
  final BehaviorSubject<String> selectedTimeScheduleId =
      BehaviorSubject<String>();

  final BehaviorSubject<int> _firstIndexController = BehaviorSubject<int>();
  final BehaviorSubject<ProductAvailableIndexModel> _indexController =
      BehaviorSubject<ProductAvailableIndexModel>();

  final BehaviorSubject<int> _optionIndexController = BehaviorSubject<int>();
  final BehaviorSubject<String> _otherIndexController =
      BehaviorSubject<String>();

  ProductAvailableIndexModel getIndex() {
    return _indexController.value;
  }

  Stream<int> get firstIndexController => _firstIndexController.stream; //oo

  Stream<int> get optionIndexController => _optionIndexController.stream;

  Stream<String> get otherIndexController => _otherIndexController.stream;

  void changeFirstIndex(int first) {
    _firstIndexController.add(first);
    model.firstIndex = first;

    model.optionIndex = 0;
    model.otherIndex = '';
    _indexController.add(model);
  }

  void changeOptionIndex(int optionIndex) {
    _optionIndexController.add(optionIndex);
    model.optionIndex = optionIndex;

    _indexController.add(model);
  }

  void changeOtherIndex(String otherIndex) {
    _otherIndexController.add(otherIndex);
    model.otherIndex = otherIndex;
    _indexController.add(model);
  }

  void clearBasicIndex() {
    _firstIndexController.add(0);
    _optionIndexController.add(0);
    model.firstIndex = 0;
    model.optionIndex = 0;
    model.otherIndex = '';
    _indexController.add(model);
  }

  void changeTimeScheduleId(String id) {
    print('change time schedule $id');
    selectedTimeScheduleId.add(id);
  }

  void dispose() {
    _indexController.close();
  }

  // Observable<ProductAvailableIndexModel> get indexList =>
  //     _indexController.stream;
}

class ProductAvailableIndexModel {
  ProductAvailableIndexModel({
    this.firstIndex = 0,
    this.optionIndex = 0,
    this.otherIndex = '',
  });

  int firstIndex;
  int optionIndex;
  String otherIndex;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstIndex': firstIndex,
        'optionIndex': optionIndex,
        'otherIndex': otherIndex,
      };
}
