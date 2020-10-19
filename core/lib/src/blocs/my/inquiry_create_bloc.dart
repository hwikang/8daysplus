import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../models/my/inquiry_create_model.dart';
import '../../models/my/inquiry_types_model.dart';
import '../../providers/my/inquiry_create_provider.dart';
import '../../providers/my/inquiry_types_provider.dart';

enum InquiryCreateState { Loading, Succeed, Failed }

class InquiryCreateBloc {
  InquiryCreateBloc() {
    fetch();
    networkState.add(NetworkState.Start);
  }

  // BehaviorSubject<InquiryCreateState> createState =
  //     BehaviorSubject<InquiryCreateState>();

  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();
  //create
  InquiryCreateProvider inquiryCreateProvider = InquiryCreateProvider();

  //types
  InquiryTypesProvider inquiryTypesProvider = InquiryTypesProvider();

  BehaviorSubject<InquiryTypeModel> selectedType =
      BehaviorSubject<InquiryTypeModel>();

  BehaviorSubject<List<InquiryTypeModel>> typeList =
      BehaviorSubject<List<InquiryTypeModel>>();

  void changeSelectedType(InquiryTypeModel type) {
    selectedType.add(type);
  }

  void fetch() {
    networkState.add(NetworkState.Loading);
    getInquiryTypes().then((data) {
      typeList.add(data);

      networkState.add(NetworkState.Normal);
    });
  }

  Future<List<InquiryTypeModel>> getInquiryTypes() {
    return inquiryTypesProvider.inquiryConnection().catchError((exception) => {
          ExceptionHandler.handleError(exception,
              networkState: networkState, retry: fetch)
        });
  }

  Future<bool> createInquiry(InquiryCreateModel model) {
    // createState.add(InquiryCreateState.Loading);
    return inquiryCreateProvider
        .createInquiry(model)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }
}
