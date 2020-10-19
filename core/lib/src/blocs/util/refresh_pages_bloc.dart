import 'package:rxdart/rxdart.dart';

class RefreshPagesBloc {
  RefreshPagesBloc() {
    changeRefresh(false);
    // refreshReservationPageController.add(false);
  }

  final BehaviorSubject<bool> refreshMyPageController = BehaviorSubject<bool>();
  final BehaviorSubject<bool> refreshReservationPageController =
      BehaviorSubject<bool>();

  final BehaviorSubject<bool> _refreshMyOrderPageController =
      BehaviorSubject<bool>();

  void changeRefresh(bool state) {
    changeReservationPageRefreshState(state);
    changeMyPageRefreshState(state);
    changeMyOrderPageRefreshState(state);
  }

  void changeReservationPageRefreshState(bool state) {
    refreshReservationPageController.add(state);
  }

  void changeMyPageRefreshState(bool state) {
    refreshMyPageController.add(state);
  }

  void changeMyOrderPageRefreshState(bool state) {
    _refreshMyOrderPageController.add(state);
  }

  bool get refreshReservationPageState =>
      refreshReservationPageController.value;

  bool get refreshMyPageState => refreshMyPageController.value;

  bool get refreshMyOrderPageState => _refreshMyOrderPageController.value;
}

RefreshPagesBloc refreshPagesBloc = RefreshPagesBloc();
