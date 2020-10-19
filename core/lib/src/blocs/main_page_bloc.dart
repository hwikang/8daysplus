import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../core.dart';
import '../providers/main_page_provider.dart';
import '../utils/network_error_handler.dart';

// enum NetworkState { Start, Finish, Loading, Done, Err }

class MainPageBloc {
  MainPageBloc({this.first, this.lat, this.lng}) {
    networkState.add(NetworkState.Start);
    repoList.add(<FeedModel>[]); //null이면 빌드시 문제생김 (ex.listview count)
    fetch();
  }

  final int first;
  final double lat;
  final double lng;
  final BehaviorSubject<String> lastCursor = BehaviorSubject<String>();
  String _lastCursor;

  MainPageProvider mainPageProvider = MainPageProvider();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final BehaviorSubject<List<FeedModel>> repoList =
      BehaviorSubject<List<FeedModel>>();

  List<FeedModel> _listStorage; //List Storage

  void dispose() {
    networkState.close();
    repoList.close();
    lastCursor.close();
  }

  Future<bool> fetch() {
    _lastCursor = '';
    return getFeedConnection(first, '', true, lat, lng).then((data) {
      if (data != null) {
        repoList.add(data['feed']);
        _lastCursor = data['lastCursor'];
        // lastCursor.add(data['lastCursor']); //마지막커서
        _listStorage = List<FeedModel>.from(data['feed']);

        if (data['feed'].length < first) {
          //페이지 네이션 종료
          networkState.add(NetworkState.Finish);
        } else {
          networkState.add(NetworkState.Normal);
        }
        return true;
      } else {
        return false;
      }
    });
  }

  void getMoreFeed() {
    networkState.add(NetworkState.Loading);
    getFeedConnection(first, _lastCursor, false, lat, lng).then((data) {
      if (data != null) {
        if (data.isEmpty) {
          networkState.add(NetworkState.Finish);
        } else {
          final newList = List<FeedModel>.from(_listStorage)
            ..addAll(data['feed']);
          repoList.add(newList);
          _lastCursor = data['lastCursor'];
          _listStorage = List<FeedModel>.from(newList);
          getLogger(this).d('data.length ${data['feed'].length}');
          if (data['feed'].length < first) {
            //페이지 네이션 종료
            networkState.add(NetworkState.Finish);
          } else {
            networkState.add(NetworkState.Normal);
          }
        }
      }
    });
  }

  Future<Map<String, dynamic>> getFeedConnection(
      int first, String cursor, bool isFetch, double lat, double lng) {
    return mainPageProvider
        .feedConnection(
          first: first,
          cursor: cursor,
          isFetch: isFetch,
          lat: lat,
          lng: lng,
        )
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }
}
