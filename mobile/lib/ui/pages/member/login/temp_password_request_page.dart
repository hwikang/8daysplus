import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../../utils/validator.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';

class TempPasswordRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Provider<TempPasswordBloc>(
        create: (context) => TempPasswordBloc(),
        child: SafeArea(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
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
                      title: MemberPageStrings.tempPasswordRequestTitle)),
              bottomNavigationBar: TempPasswordRequestBottom(formKey: _formKey),
              body: Container(
                  margin: const EdgeInsets.all(24),
                  child: TempPasswordRequestBody(formKey: _formKey))),
        )));
  }
}

class TempPasswordRequestBottom extends StatelessWidget {
  const TempPasswordRequestBottom({this.formKey});
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<TempPasswordBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.emailController,
      builder: (context, snapshot) {
        print(snapshot.data);
        final isUnabled = snapshot.data == null || snapshot.data == '';
        return Container(
          height: 46,
          margin: EdgeInsets.all(24),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: BlackButtonWidget(
                isUnabled: isUnabled,
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    bloc.submit().then((result) {
                      AppRoutes.tempPasswordCompletePage(
                          context, bloc.getEmail());
                    }).catchError((error) {
                      print(error);
                      if (error.contains('error_msg')) {
                        final Map<String, dynamic> map = json.decode(error);

                        DialogWidget.buildDialog(
                          context: context,
                          title: '에러',
                          subTitle1: map['error_msg'],
                        );
                      } else {
                        DialogWidget.buildDialog(
                          context: context,
                          subTitle1: '$error',
                          title: '에러',
                        );
                      }
                    });
                  }
                },
                title: '발급',
              ))
            ],
          ),
        );
      },
    );
  }
}

class TempPasswordRequestBody extends StatelessWidget {
  const TempPasswordRequestBody({this.formKey});
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          MemberPageStrings.tempPasswordRequestIntro,
          style: TextStyles.black20BoldTextStyle,
        ),
        const SizedBox(height: 12),
        Text(
          MemberPageStrings.tempPasswordRequestIntroSub,
          style: TextStyles.black16TextStyle,
        ),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8, right: 24),
          child: Text(
            MemberPageStrings.id,
            style: TextStyles.grey14TextStyle,
          ),
        ),
        Form(
          key: formKey,
          child: emailField(context),
        ),
        Expanded(child: Container()),
        Container(
            alignment: Alignment.bottomLeft,
            height: 110,
            child: Text(
              MemberPageStrings.tempPasswordGuideMessage,
              style: TextStyles.black14TextStyle,
            )),
        // _buildSendPasswordButton(context),
      ],
    );
  }

  Widget emailField(BuildContext context) {
    final bloc = Provider.of<TempPasswordBloc>(context);
    return StreamBuilder<String>(
        stream: bloc.emailController,
        initialData: '',
        builder: (context, snapshot) {
          return TextFormFieldWidget(
              initialValue: snapshot.data,
              onChanged: bloc.changeEmail,
              keyboardType: TextInputType.emailAddress,
              hintText: '이메일 주소 입력',
              errorText: snapshot.error,
              validator: FieldValidator.validateEmail);
        });
  }
}
