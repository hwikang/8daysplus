import '../../../../core.dart';

class UpdateProfileBloc {
  UpdateProfileProvider updateProfileProvider = UpdateProfileProvider();

  Future<bool> updateProfile({
    String name,
    String birthDay,
    String birthMonth,
    String birthYear,
    String countryCode,
    String mobile,
  }) {
    final model = UpdateProfileInputModel(
      name: name,
      birthDay: birthDay,
      birthMonth: birthMonth,
      birthYear: birthYear,
      mobile: mobile,
      countryCode: countryCode,
    );

    return updateProfileProvider
        .updateProfile(model)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
