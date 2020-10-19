import 'package:rxdart/rxdart.dart';

import '../../../../core.dart';

class MyStyleSelectPageBloc {
  MyStyleSelectPageBloc() {
    getRecommendPicks();
    isLast.add(false);
  }

  BehaviorSubject<bool> isLast = BehaviorSubject<bool>();
  int pickCount = 0;
// pick 갯수
  BehaviorSubject<int> pickCountController = BehaviorSubject<int>();

  List<ProductListViewModel> productList;
  //프로덕트 리스트
  BehaviorSubject<List<ProductListViewModel>> productListController =
      BehaviorSubject<List<ProductListViewModel>>();

  BehaviorSubject<Map<String, dynamic>> repoJson =
      BehaviorSubject<Map<String, dynamic>>();

  void dispose() {
    repoJson.close();
    pickCountController.close();
    isLast.close();
    productListController.close();
    productList.clear();
  }

  void onLastPage() {
    isLast.add(true);
  }

  void onOtherPage() {
    isLast.add(false);
  }

  void removeItemFromList(String productId, double pageIndex) {
    productList.removeWhere((product) {
      return productId == product.id;
    });
    productListController.add(productList);
    if (productList.length == pageIndex) {
      //남은 상품갯수 == 현재페이지 =>마지막페이지
      onLastPage();
    }
  }

  void pick() {
    pickCount++;
    pickCountController.add(pickCount);
  }

  Future<Map<String, dynamic>> getRecommendPicks() {
    final recommendPicksProvider = RecommendPicksProvider();
    return recommendPicksProvider.recommendPicks().then((data) {
      repoJson.add(data);
      productList = data['feedPickProducts'];
      productListController.add(productList);
      return data;
    });
  }

  Future<bool> addRecommendPick(String productId, String typeName) {
    final inputModel =
        AddRecommendPickInputModel(productId: productId, type: typeName);
    final addRecommendPickProvider = AddRecommendPickProvider();

    return addRecommendPickProvider.addRecommendPick(inputModel).then((res) {
      if (res) {
        //선택한거 제거

        pick();
        // removeItemFromList(productId);
        return res;
      }
      return false;
    });
  }
}
