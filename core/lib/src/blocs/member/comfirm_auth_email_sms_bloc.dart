// import 'dart:async';

// import '../../../core.dart';

// class ConfirmAuthEmailSMSBloc {
//   ConfirmAuthEmailSMSProvider confirmAuthEmailSMSProvider =
//       ConfirmAuthEmailSMSProvider();

//   // final BehaviorSubject<String> _confirmMobileController =
//   //     BehaviorSubject<String>();

//   // // Observable<String> get verifyMobileStream => _confirmMobileController.stream;

//   // void dispose() {
//   //   _confirmMobileController.close();
//   // }

//   Future<String> confirmAuthEmailFormSMS(
//       String countryCode, String mobileNum, String verifyCode) {
//     final model = ConfirmAuthMobileModel(
//         countryCode: countryCode, mobile: mobileNum, verifyCode: verifyCode);

//     return confirmAuthEmailSMSProvider
//         .confirmAuthEmailFormSMS(model)
//         .then((result) {
//       print('confirm auth email sms $result');
//       // retVal = true;
//       return result;
//       //dispose();
//     });
//     // .catchError((dynamic err) {
//     //   print('catch error from confirm email auth bloc $err');
//     //   print(json.decode(err));
//     //   final Map<String, dynamic> map = json.decode(err);
//     //   print(map['error_msg']);
//     //   // print(err);

//     //   throw map['error_msg'];
//     // });
//   }
// }
