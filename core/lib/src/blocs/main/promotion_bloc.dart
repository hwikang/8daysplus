import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../models/main/feed_promotion_model.dart';
import '../../providers/main/promotion_provider.dart';

class PromotionBloc {
  PromotionBloc({
    @required this.id,
  }) {
    fetch();
  }

  final String id;
  final PromotionProvider promotionProvider = PromotionProvider();
  final BehaviorSubject<FeedPromotionModel> repoData =
      BehaviorSubject<FeedPromotionModel>();

  void fetch() {
    getPromotionDataRepos(id)
        .then(repoData.add)
        .catchError((dynamic error) => {repoData.addError(error)});
  }

  Future<FeedPromotionModel> getPromotionDataRepos(String id) {
    return promotionProvider
        .promotion(id)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  void dispose() {
    repoData.close();
  }
}
