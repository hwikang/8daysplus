import 'package:rxdart/rxdart.dart';

enum NetworkState {
  Start,
  Normal,
  NetworkError,
  LoginError,
  Failed,
  Retry,
  Changing,
  Finish, //pagination
  Loading //pagination
}

final BehaviorSubject<NetworkState> appNetworkState =
    BehaviorSubject<NetworkState>();
