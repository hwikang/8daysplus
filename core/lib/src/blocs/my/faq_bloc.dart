import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../models/my/faq_model.dart';
import '../../providers/my/faq_provider.dart';

enum FaqState { Normal, Loading, Done, Finish }

class FaqBloc {
  FaqBloc({this.first, this.type}) {
    // faqState.add(FaqState.Loading);
    networkState.add(NetworkState.Start);
    search(type);
  }

  final BehaviorSubject<List<FaqModel>> faqList =
      BehaviorSubject<List<FaqModel>>();

  final FaqProvider faqProvider = FaqProvider();
  // final BehaviorSubject<FaqState> faqState = BehaviorSubject<FaqState>();
  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  final int first;
  final BehaviorSubject<String> lastCursor = BehaviorSubject<String>();
  final BehaviorSubject<Map<String, dynamic>> repoList =
      BehaviorSubject<Map<String, dynamic>>();

  final String type;
  final BehaviorSubject<List<FaqTypeModel>> typeList =
      BehaviorSubject<List<FaqTypeModel>>();

  List<FaqModel> _listStorage = <FaqModel>[];

  void getMore(String type) {
    print('get more called');

    getFaqList(lastCursor.value, type).then((data) {
      if (data['faqList'].isEmpty) {
        networkState.add(NetworkState.Finish);
        // faqState.add(FaqState.Finish);
      } else {
        final newList = List<FaqModel>.from(_listStorage)
          ..addAll(data['faqList']);
        print(newList);

        repoList.add(data);
        faqList.add(newList);
        _listStorage = List<FaqModel>.from(newList);
        // typeList.add(data['typeList']);
        lastCursor.add(data['lastCursor']);

        // faqState.add(FaqState.Done);
        networkState.add(NetworkState.Normal);
        print(data);
      }
    });
  }

  void search(String type) {
    lastCursor.add('');
    _listStorage.clear();
    getFaqList('', type).then((data) {
      print('data $data');
      if (data['faqList'].isEmpty) {
        networkState.add(NetworkState.Finish);
        // faqState.add(FaqState.Finish);
        repoList.add(data);
        faqList.add(<FaqModel>[]);
        typeList.add(data['typeList']); //탭 리스트
      } else {
        repoList.add(data);
        faqList.add(data['faqList']); //콘텐츠 리스트
        _listStorage = List<FaqModel>.from(data['faqList']);
        typeList.add(data['typeList']); //탭 리스트
        lastCursor.add(data['lastCursor']);
        if (data['faqList'].length < first) {
          networkState.add(NetworkState.Finish);
        } else {
          networkState.add(NetworkState.Normal);
        }
      }
    });
  }

  Future<Map<String, dynamic>> getFaqList(String after, String type) {
    networkState.add(NetworkState.Loading);
    return faqProvider
        .faqConnection(first, after, type)
        .catchError((exception) => {
              ExceptionHandler.handleError(exception,
                  networkState: networkState, retry: () {
                search(type);
              })
            });
  }

  void dispose() {
    faqList.close();
    typeList.close();
  }
}
