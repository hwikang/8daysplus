import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../core.dart';

class RecommendBloc {
  RecommendBloc({
    @required this.productId,
    @required this.typeName,
    @required this.neighbor,
  }) {
    fetch();
  }

  final String productId;
  final String typeName;
  final bool neighbor;
  final RecommendProvider recommendProvider = RecommendProvider();
  final BehaviorSubject<List<ProductListViewModel>> repoList =
      BehaviorSubject<List<ProductListViewModel>>();

  // final BehaviorSubject<StateEvent> _stateController =
  // BehaviorSubject<StateEvent>();

  void fetch() {
    getRecommendListRepos(productId, typeName)
        .then((data) => {repoList.add(data)});
  }

  Future<List<ProductListViewModel>> getRecommendListRepos(
      String productId, String typeName) {
    return recommendProvider
        .recommendation(productId, typeName, neighbor)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  // Function(StateEvent) get dispatchStateEvent => _stateController.sink.add;

  // Stream<StateEvent> get state =>
  // _stateController.stream.transform(validateState);

  void dispose() {
    repoList.close();
    // _stateController.close();
  }
}
