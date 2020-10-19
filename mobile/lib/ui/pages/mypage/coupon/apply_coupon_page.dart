import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/handle_network_error.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/text_form_field_widget.dart';

class ApplyCouponPage extends StatefulWidget {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  _ApplyCouponPageState createState() => _ApplyCouponPageState();
}

class _ApplyCouponPageState extends State<ApplyCouponPage> {
  String couponId;
  bool stopProgress;
  @override
  void initState() {
    super.initState();
    stopProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            //when pop this page, button function will be stop
            setState(() {
              stopProgress = true;
            });
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: '쿠폰 등록'),
      ),
      body: Form(
        key: ApplyCouponPage.formKey,
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              TextFormFieldWidget(
                hintText: '프로모션 코드를 입력해 주세요',
                validator: (data) {
                  return null;
                },
                onSaved: (id) {
                  setState(() {
                    couponId = id;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: 312 * DeviceRatio.scaleWidth(context),
                child: BlackButtonWidget(
                  title: '쿠폰 등록',
                  onPressed: () {
                    if (ApplyCouponPage.formKey.currentState.validate()) {
                      if (!stopProgress) {
                        ApplyCouponPage.formKey.currentState.save();
                        final applyCouponBloc = ApplyCouponBloc();
                        applyCouponBloc.getCoupon(couponId).then((result) {
                          if (result.status) {
                            DialogWidget.buildDialog(
                                context: context,
                                title: '쿠폰 등록 성공',
                                onPressed: () => Navigator.pop(context),
                                buttonTitle: '확인');
                          } else {
                            DialogWidget.buildDialog(
                                context: context,
                                title: result.message,
                                onPressed: () => Navigator.pop(context),
                                buttonTitle: '확인');
                          }
                        }).catchError((error) {
                          HandleNetworkError.showErrorDialog(context, error);
                        });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
