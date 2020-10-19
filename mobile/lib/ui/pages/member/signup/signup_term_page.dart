// import 'package:circular_check_box/circular_check_box.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/circular_checkbox_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';

class SignUpTermPage extends StatelessWidget {
  const SignUpTermPage({this.servicePolicies});

  final ServicePolicyInfoModel servicePolicies;

  Widget _buildTermsBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
            child: Text(
              MemberPageStrings.signUpTerm_title,
              style: TextStyles.black20BoldTextStyle,
            ),
          ),
          _buildTermAll(context),
          _buildTermService(context),
          _buildTermPrivate(context),
          _buildTermLocation(context),
          _buildTerm14yearsOver(context),
          _buildTermMarketing(context),
        ],
      ),
    );
  }

  Widget requiredTermWidget(
      {BuildContext context,
      String title,
      bool isAgreed,
      Function onCheck,
      Function onLinkTap}) {
    return Container(
        height: 24,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: onCheck,
              child: Row(
                children: [
                  CircularCheckBoxWiget(
                    isAgreed: isAgreed,
                  ),
                  Text(MemberPageStrings.signUpTerm_required,
                      style: TextStyles.orange14TextStyle),
                ],
              ),
            ),
            GestureDetector(
              onTap: onLinkTap,
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: TextStyles.grey14UnderlineTextStyle,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildTermAll(BuildContext context) {
    return StreamBuilder<bool>(
        stream: signUpBloc.termAllController,
        builder: (context, snapshot) {
          var checkbox = snapshot.data;
          checkbox ??= false;
          return GestureDetector(
            onTap: () {
              signUpBloc.addTermAll(!checkbox);
            },
            child: Container(
                height: 24,
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircularCheckBoxWiget(
                      isAgreed: checkbox,
                    ),
                    Text(
                      MemberPageStrings.signUpTerm_agreeAll,
                      style: TextStyles.black16BoldTextStyle,
                    ),
                  ],
                )),
          );
        });
  }

  Widget _buildTermService(BuildContext context) {
    return StreamBuilder<bool>(
        stream: signUpBloc.termServiceController,
        builder: (context, snapshot) {
          var checkbox = snapshot.data;
          checkbox ??= false;
          return requiredTermWidget(
              context: context,
              title: MemberPageStrings.signUpTerm_agreeService,
              isAgreed: checkbox,
              onCheck: () {
                signUpBloc.addTermService(!checkbox);
              },
              onLinkTap: () {
                AppRoutes.buildTitledModalBottomSheet(
                  context: context,
                  title: MemberPageStrings.signUpTerm_agreeService,
                  child: WebviewScaffold(
                    url: servicePolicies.serviceUseTermsUrl,
                  ),
                );
              });
        });
  }

  Widget _buildTermPrivate(BuildContext context) {
    return StreamBuilder<bool>(
        stream: signUpBloc.termPrivateController,
        builder: (context, snapshot) {
          var checkbox = snapshot.data;
          checkbox ??= false;
          return requiredTermWidget(
              context: context,
              title: MemberPageStrings.signUpTerm_agreePersonalInfo,
              isAgreed: checkbox,
              onCheck: () {
                signUpBloc.addTermPrivate(!checkbox);
              },
              onLinkTap: () {
                print('ontap ${servicePolicies.personalInfoUrl}');
                AppRoutes.buildTitledModalBottomSheet(
                  context: context,
                  title: MemberPageStrings.signUpTerm_agreePersonalInfo,
                  child: WebviewScaffold(
                    url: servicePolicies.personalInfoUrl,
                  ),
                );
              });
        });
  }

  Widget _buildTermLocation(BuildContext context) {
    return StreamBuilder<bool>(
        stream: signUpBloc.termLocationController,
        builder: (context, snapshot) {
          var checkbox = snapshot.data;
          checkbox ??= false;
          return requiredTermWidget(
              context: context,
              title: MemberPageStrings.signUpTerm_agreeLocation,
              isAgreed: checkbox,
              onCheck: () {
                signUpBloc.addTermLocation(!checkbox);
              },
              onLinkTap: () {
                AppRoutes.buildTitledModalBottomSheet(
                  context: context,
                  title: MemberPageStrings.signUpTerm_agreeLocation,
                  child: WebviewScaffold(
                    url: servicePolicies.locationUseTermsUrl,
                  ),
                );
              });
        });
  }

  Widget _buildTerm14yearsOver(BuildContext context) {
    return Container(
        height: 48,
        margin: const EdgeInsets.only(left: 54, right: 11, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                MemberPageStrings.signUpTerm_overFourTeen,
                maxLines: 2,
                style: TextStyles.grey14TextStyle,
              ),
            ),
          ],
        ));
  }

  Widget _buildTermMarketing(BuildContext context) {
    return StreamBuilder<bool>(
        stream: signUpBloc.termMarketingController,
        builder: (context, snapshot) {
          var checkbox = snapshot.data;
          checkbox ??= false;
          return GestureDetector(
              onTap: () {
                signUpBloc.addTermMarketing(!checkbox);
              },
              child: Container(
                  height: 24,
                  margin:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircularCheckBoxWiget(
                        isAgreed: checkbox,
                      ),
                      Text(
                        MemberPageStrings.signUpTerm_option,
                        style: TextStyles.black14TextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          MemberPageStrings.signUpTerm_agreeMarketing,
                          style: TextStyles.grey14TextStyle,
                        ),
                      ),
                    ],
                  )));
        });
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
          child: BlackButtonWidget(
            onPressed: () {
              final termRequired = signUpBloc.termRequired();
              if (!termRequired) {
                return DialogWidget.buildDialog(
                    context: context,
                    title: MemberPageStrings.signUpTerm_disAgreeTitle,
                    subTitle1: MemberPageStrings.signUpTerm_disAgreeSubtitle,
                    onPressed: () {
                      Navigator.of(context).pop(); //mypage-main
                    });
              } else {
                // AppRoutes.emailAuthPage(context);
                final now = DateTime.now();
                final formattedDate = DateFormat('yyyy년MM월dd일').format(now);
                var okText = '';
                if (signUpBloc.termMarketting()) {
                  okText =
                      MemberPageStrings.signUpTerm_marketingAlertStateAgree;
                } else {
                  okText =
                      MemberPageStrings.signUpTerm_marketingAlertStateDisagree;
                }
                DialogWidget.buildDialog(
                    context: context,
                    title: MemberPageStrings.signUpTerm_marketingAlertTitle,
                    subTitle1:
                        '${MemberPageStrings.signUpTerm_marketingAlertSender}\n${MemberPageStrings.signUpTerm_marketingAlertDate} $formattedDate\n${MemberPageStrings.signUpTerm_marketingAlertState} $okText',
                    buttonTitle: CommonTexts.confirmButton,
                    onPressed: () {
                      if (signUpBloc.getLoginType() == 'EMAIL') {
                        final abloc = AuthEmailBloc();
                        //send email
                        abloc.authEmail(signUpBloc.getUserID()).then((retVal) {
                          if (retVal) {
                            Navigator.of(context).pop();
                            AppRoutes.emailAuthPage(
                                context, signUpBloc.getUserID(), 'SIGNUP');
                          } else {
                            Navigator.of(context).pop();
                          }
                        }).catchError((error) {
                          Navigator.of(context).pop();
                          DialogWidget.buildDialog(
                            context: context,
                            title: error,
                          );
                        });
                      } else {
                        print('sns login ok');
                        Navigator.of(context).pop();

                        AppRoutes.signUpCompletePage(context);
                      }
                    });
              }
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Sign_Up_terms');
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(
          title: MemberPageStrings.signUpTerm_title,
        ),
      ),
      bottomNavigationBar: _buildSignUpButton(context),
      body: _buildTermsBody(context),
    );
  }
}
