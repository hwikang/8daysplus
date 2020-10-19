import '../../../../core.dart';
import '../../../models/my/profile/update_password_model.dart';
import '../../../providers/my/update_password_provider.dart';

enum UpdatePasswordState { Normal, Logging, Success, Failed }

class UpdatePasswordBloc {
  UpdatePasswordBloc() {
    // updatePasswordState.add(UpdatePasswordState.Normal);
  }

  // final BehaviorSubject<String> errorMsg = BehaviorSubject<String>();
  UpdatePasswordProvider updatePasswordProvider = UpdatePasswordProvider();
  // final BehaviorSubject<UpdatePasswordState> updatePasswordState =
  //     BehaviorSubject<UpdatePasswordState>();

  void changeState(UpdatePasswordState state) {
    // updatePasswordState.add(state);
  }

  // void update(UpdatePasswordModel model) {
  //   // updatePasswordState.add(UpdatePasswordState.Logging);
  //   updatePasswordConnection(model);
  // }

  Future<bool> update(UpdatePasswordModel model) {
    return updatePasswordProvider
        .updatePasswordConnection(model)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
    // .then<bool>((dynamic isUpdate) {
    // print('update in bloc $isUpdate');
    // updatePasswordState.add(UpdatePasswordState.Success);
    // return isUpdate;
    // })
    // .catchError((dynamic err) {
    // print('bloc err ${err[0].message}');
    // final Map<String, dynamic> map = json.decode(err[0].message);
    // print(map['message']);
    // errorMsg.add(map['message']);
    // updatePasswordState.add(UpdatePasswordState.Failed);
    // });
  }

  void dispose() {
    print('called dispose passwork bloc');
    // updatePasswordState.close();
    // errorMsg.close();
  }
}
