import '../../../core.dart';

class ServicePolicyInfoBloc {
  final servicePolicyInfoProvider = ServicePolicyInfoProvider();

  Future<ServicePolicyInfoModel> servicePolicyInfo() {
    return servicePolicyInfoProvider
        .servicePolicyInfo()
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }
}
