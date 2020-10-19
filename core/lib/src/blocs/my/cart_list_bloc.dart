import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../models/my/cart_list_view_model.dart';
import '../../providers/my/cart_list_provider.dart';
import '../../states/network_state.dart';

class CartListBloc {
  CartListBloc({this.first = 10}) {
    fetch('');
    selectedItems.add(<String, int>{'selectedItemLength': 0, 'totalPrice': 0});
    // networkState.add(NetworkState.Normal);
  }

  final cartListProvider = CartListProvider();
  // final deleteCartProvider = DeleteCartProvider();
  final int first;
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final BehaviorSubject<List<CartListViewModel>> repoList =
      BehaviorSubject<List<CartListViewModel>>();

  BehaviorSubject<Map<String, int>> selectedItems =
      BehaviorSubject<Map<String, int>>();

  String _lastCursor;
  final List<CartListViewModel> _listToBuy = <CartListViewModel>[];
  int _totalPrice = 0;

  void fetch(String after) {
    getCartList(after).then((data) {
      repoList.add(data['nodes']);
      _lastCursor = data['lastCursor'];
      if (data['nodes'].length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  void getMoreCartList() {
    networkState.add(NetworkState.Loading);
    getCartList(_lastCursor).then((data) {
      final tempList = <CartListViewModel>[];
      tempList..addAll(repoList.value)..addAll(data['nodes']);
      repoList.add(tempList);
      _lastCursor = data['lastCursor'];
      if (data['nodes'].length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  Future<Map<String, dynamic>> getCartList(String after) {
    return cartListProvider
        .cartConnection(first, after)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: () {
                fetch(after);
              })
            });
  }

  void dispose() {
    repoList.close();
  }

  void addCartList(CartListViewModel item, int itemTotalPrice) {
    print(item.id);
    _listToBuy.add(item);
    _totalPrice += itemTotalPrice;
    selectedItems.add(<String, int>{
      'selectedItemLength': _listToBuy.length,
      'totalPrice': _totalPrice
    });
    print(_listToBuy);
  }

  void removeCartList(CartListViewModel item, int itemTotalPrice) {
    final isRemoved = _listToBuy.remove(item);
    if (isRemoved) {
      _totalPrice -= itemTotalPrice;
    }
    selectedItems.add(<String, int>{
      'selectedItemLength': _listToBuy.length,
      'totalPrice': _totalPrice
    });
    print(_listToBuy);
  }

  Future<bool> deleteFromCart(CartListViewModel item, int itemTotalPrice) {
    final deleteCartBloc = DeleteCartBloc();
    return deleteCartBloc.deleteCart(<String>[item.id]).then((res) {
      if (res) {
        final removedList = repoList.value.where((cartItem) {
          return cartItem.id != item.id;
        }).toList();
        repoList.add(removedList); //지우면 바로 ui 적용
        removeCartList(item, itemTotalPrice); // 쿠폰 선택리스트 에서 제외

        return true;
      }
      return false;
    });
  }

  List<CartListViewModel> getSelectedList() {
    return _listToBuy;
  }
}
