import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core.dart';

class ProductDetailBloc {
  ProductDetailBloc({this.productId, this.productType}) {
    networkState.add(NetworkState.Normal);

    fetch();
  }

  BehaviorSubject<dynamic> couponList = BehaviorSubject<dynamic>();
  BehaviorSubject<String> errMessage = BehaviorSubject<String>();
  BehaviorSubject<NetworkState> networkState = BehaviorSubject<NetworkState>();
  final ProductDetailProvider productDetailProvider = ProductDetailProvider();
  String productId;

  BehaviorSubject<ProductDetailViewModel> productModel =
      BehaviorSubject<ProductDetailViewModel>();

  String productType;
  final BehaviorSubject<Map<String, dynamic>> repoData =
      BehaviorSubject<Map<String, dynamic>>();

  void fetch() {
    networkState.add(NetworkState.Start);
    getProductDetailRepos().then(
      (data) {
        networkState.add(NetworkState.Normal);
        productModel.add(data['product']);
        couponList.add(data['couponList']);
        repoData.add(data);
      },
    );
  }

  Future<Map<String, dynamic>> getProductDetailRepos() {
    return productDetailProvider
        .product(productId, productType)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }

  void dispose() {
    networkState.close();
    repoData.close();
    errMessage.close();
    productModel.close();
    couponList.close();
  }
}
