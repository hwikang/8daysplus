import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../models/main/feed_alarm_model.dart';
import '../../providers/main/main_alarm_provider.dart';
import '../../states/network_state.dart';

class MainAlarmBloc {
  MainAlarmBloc({
    @required this.first,
  }) {
    fetch();
  }

  final int first;
  final MainAlarmProvider mainAlarmProvider = MainAlarmProvider();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final BehaviorSubject<List<FeedMainAlarmModel>> repoList =
      BehaviorSubject<List<FeedMainAlarmModel>>();

  String _lastCursor;
  List<FeedMainAlarmModel> _listAll = <FeedMainAlarmModel>[];

  void fetch() {
    getAlarmDataRepos(first).then((data) {
      // data[first-1].
      _lastCursor = data['lastCursor'];
      repoList.add(data['nodes']);
      _listAll = List<FeedMainAlarmModel>.from(data['nodes']);

      if (data['nodes'].length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  void getMoreAlarm() {
    mainAlarmProvider.alarmConnection(first, _lastCursor).then((dynamic data) {
      final newList = List<FeedMainAlarmModel>.from(_listAll)
        ..addAll(data['nodes']);
      repoList.add(newList);
      _listAll = List<FeedMainAlarmModel>.from(newList);
      _lastCursor = data['lastCursor'];
      print('length ${_listAll.length}');
      if (data['nodes'].length < first) {
        networkState.add(NetworkState.Finish);
      } else {
        networkState.add(NetworkState.Normal);
      }
    });
  }

  Future<Map<String, dynamic>> getAlarmDataRepos(int first) {
    return mainAlarmProvider
        .alarmConnection(first, '')
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }

  void dispose() {
    repoList.close();
  }
}
