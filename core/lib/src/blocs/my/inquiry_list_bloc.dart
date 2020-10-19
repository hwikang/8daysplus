import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/my/inquiry_list_model.dart';
import '../../providers/my/inquiry_list_provider.dart';
import '../../states/network_state.dart';

// enum NetworkState { Normal, Loading, Done, Finish }

class InquiryListBloc {
  InquiryListBloc({
    this.first,
  }) {
    networkState.add(NetworkState.Start);
    fetch('');
  }

  final int first;
  final BehaviorSubject<List<InquiryListModel>> inquiryList =
      BehaviorSubject<List<InquiryListModel>>();

  final InquiryListProvider inquiryProvider = InquiryListProvider();
  final BehaviorSubject<String> lastCursor = BehaviorSubject<String>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final BehaviorSubject<Map<String, dynamic>> repoList =
      BehaviorSubject<Map<String, dynamic>>();

  List<InquiryListModel> _listStorage = <InquiryListModel>[];

  void getMore() {
    print('get more called');
    networkState.add(NetworkState.Loading);
    fetch(lastCursor.value);
  }

  void fetch(String after) {
    getInquiryList(after).then((data) {
      if (data['inquiryList'].isEmpty) {
        networkState.add(NetworkState.Finish);
      } else {
        final newList = List<InquiryListModel>.from(_listStorage)
          ..addAll(data['inquiryList']);
        print(newList);

        repoList.add(data);
        inquiryList.add(newList);
        _listStorage = List<InquiryListModel>.from(newList);

        lastCursor.add(data['lastCursor']);
        networkState.add(NetworkState.Normal);
        //갯수적으면 finish
        if (data['inquiryList'].length < first) {
          networkState.add(NetworkState.Finish);
        }
        print(data);
      }
    });
  }

  Future<Map<String, dynamic>> getInquiryList(String after) {
    return inquiryProvider
        .inquiryConnection(first, after)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: fetch)
            });
  }

  void dispose() {
    repoList.close();
    inquiryList.close();
    networkState.close();
  }
}
