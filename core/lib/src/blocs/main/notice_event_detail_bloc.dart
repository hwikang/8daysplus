import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/main/notice_event_model.dart';
import '../../providers/main/notice_event_provider.dart';

class NoticeEventDetailBloc {
  NoticeEventDetailBloc({this.id}) {
    fetch();
  }

  String id;
  BehaviorSubject<NoticeEventModel> noticeEvent =
      BehaviorSubject<NoticeEventModel>();

  NoticeEventProvider noticeEventProvider = NoticeEventProvider();

  void fetch() {
    getNoticeEventDetail(id).then((result) {
      noticeEvent.add(result);
    }).catchError((error) => {noticeEvent.addError(error)});
  }

  Future<NoticeEventModel> getNoticeEventDetail(String id) {
    return noticeEventProvider
        .noticeEvent(id)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
