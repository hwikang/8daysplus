import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../models/my/notice_list_view_model.dart';
import '../../providers/my/notice_list_provider.dart';

class NoticeListBloc {
  NoticeListBloc({this.first}) {
    networkState.add(NetworkState.Start);
    fetch();
  }

  final int first;
  final NoticeListProvider noticeListProvider = NoticeListProvider();
  final BehaviorSubject<List<NoticeListViewModel>> repoList =
      BehaviorSubject<List<NoticeListViewModel>>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  void fetch() {
    networkState.add(NetworkState.Loading);
    getNoticeList().then((data) {
      repoList.add(data);
      networkState.add(NetworkState.Normal);
    });
  }

  Future<List<NoticeListViewModel>> getNoticeList() {
    return noticeListProvider
        .noticeConnection(first)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
                networkState: networkState,
                retry: fetch,
              )
            });
  }

  void dispose() {
    repoList.close();
  }
}
