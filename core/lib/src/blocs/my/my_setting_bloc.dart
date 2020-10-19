import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../../core.dart';

class MySettingBloc {
  MySettingBloc() {
    networkState.add(NetworkState.Start);
    fetch();
  }
  BehaviorSubject<AlarmAgreementModel> alarmAgreement =
      BehaviorSubject<AlarmAgreementModel>();

  BehaviorSubject<ServicePolicyInfoModel> servicePolicyInfo =
      BehaviorSubject<ServicePolicyInfoModel>();

  final BehaviorSubject<NetworkState> networkState =
      BehaviorSubject<NetworkState>();

  void fetch() {
    getMyPageSettingRepos().then((data) {
      servicePolicyInfo.add(data['servicePolicyInfo']);
      alarmAgreement.add(data['alarmAgreement']);
      networkState.add(NetworkState.Normal);
    });
  }

  MyPageSettingProvider myPageSettingProvider = MyPageSettingProvider();

  Future<Map<String, dynamic>> getMyPageSettingRepos() {
    networkState.add(NetworkState.Loading);
    return myPageSettingProvider.myPageSetting().catchError((exception) => {
          ExceptionHandler.handleError(exception,
              networkState: networkState, retry: fetch)
        });
  }

  UpdateAlarmAgreementProvider updateAlarmAgreementProvider =
      UpdateAlarmAgreementProvider();

  Future<bool> updateAlarmAgreement(AlarmAgreementModel model) {
    return updateAlarmAgreementProvider
        .updateAlarmAgreement(model)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }

  void dispose() {
    alarmAgreement.close();
    servicePolicyInfo.close();
  }
}
