import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/singleton.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/user/auth_phone_widget.dart';

class MemberPhonePage extends StatefulWidget {
  @override
  _MemberPhonePageState createState() => _MemberPhonePageState();
}

class _MemberPhonePageState extends State<MemberPhonePage> {
  String authCode;
  TextEditingController authCodeEditingController;
  AuthPhoneState authPhoneState;
  String countryCode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone;
  TextEditingController phoneTextEditingController;
  int setTime;

  @override
  void initState() {
    super.initState();
    countryCode = '+82';
    setTime = 10;
    authPhoneState = AuthPhoneState.NONE;
    phoneTextEditingController = TextEditingController();
    authCodeEditingController = TextEditingController();
  }

  void authPhoneStateChange(AuthPhoneState state) {
    setState(() {
      authPhoneState = state;
    });
  }

  void countryCodeChange(String code) {
    setState(() {
      countryCode = code;
    });
  }

  void changePhone(String number) {
    setState(() {
      phone = number;
    });
  }

  void changeAuthCode(String code) {
    setState(() {
      authCode = code;
    });
  }

  Widget _buildStartButton(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.all(24),
            child: BlackButtonWidget(
              title: '다음',
              isUnabled: authCode == null || authCode == '',
              onPressed: () {
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();

                  if (Singleton.instance.serverUrl == GRAPHQL_DEV_URL) {
                    //debug 문자안날라옴
                    final servicePolicyInfoBloc = ServicePolicyInfoBloc();
                    signUpBloc.saveCountryCode(countryCode);
                    signUpBloc.savePhone(phone);
                    servicePolicyInfoBloc
                        .servicePolicyInfo()
                        .then((servicePolicies) {
                      AppRoutes.termsAuthPage(context, servicePolicies);
                    }).catchError((error) {
                      getLogger(this).w(error);
                    });
                  } else {
                    final cbloc = ConfirmMobileBloc();
                    cbloc
                        .confirmAuthSms(countryCode, phone, authCode)
                        .then((retVal) {
                      if (retVal) {
                        signUpBloc.saveCountryCode(countryCode);
                        signUpBloc.savePhone(phone);

                        final servicePolicyInfoBloc = ServicePolicyInfoBloc();
                        servicePolicyInfoBloc
                            .servicePolicyInfo()
                            .then((servicePolicies) {
                          AppRoutes.termsAuthPage(context, servicePolicies);
                        }).catchError(print);
                        // AppRoutes.termsAuthPage(context);

                      } else {
                        DialogWidget.buildDialog(
                            context: context,
                            title: '실패',
                            subTitle1: '문자 인증에 실패하였습니다.\n다시 시도해주세요.');
                      }
                    }).catchError((dynamic err) {
                      DialogWidget.buildDialog(
                          context: context, title: err, buttonTitle: '확인');
                    });
                  }
                }
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    // final phoneNumTextController = TextEditingController();
    // final authCodeTextController = TextEditingController();
    final sendAuthMobileBloc = SendAuthSmsBloc();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
        ),
        bottomNavigationBar: _buildStartButton(context),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    // margin: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      '상품 예약 및 고객 상담을 위한\n휴대폰 번호를 입력하세요.',
                      maxLines: 2,
                      style: TextStyle(
                        color: const Color(0xff404040),
                        fontFamily: FontFamily.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Text(
                      '휴대폰 번호',
                      style: TextStyles.grey14TextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AuthPhoneWidget(
                      authPhoneState: authPhoneState,
                      setTime: setTime,
                      // countDown: countDown,
                      formKey: formKey,
                      authPhoneStateChange: authPhoneStateChange,
                      countryCodeChange: countryCodeChange,
                      changePhone: changePhone,
                      changeAuthCode: changeAuthCode,
                      phoneTextEditingController: phoneTextEditingController,
                      sendSmsFunction: sendAuthMobileBloc.sendAuthSms
                      // periodicTimeChange: periodicTimeChange
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
