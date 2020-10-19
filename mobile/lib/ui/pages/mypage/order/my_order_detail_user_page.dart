import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/style.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/white_button_widget.dart';
import '../../../components/common/customer_center_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/user/user_info_widget.dart';

class MyOrderDetailUserPage extends StatelessWidget {
  const MyOrderDetailUserPage({this.orderInfo, this.orderCode, this.index});

  final int index;
  final String orderCode;
  final CreateOrderInputModel orderInfo;

  Widget _buildRefundPolicy(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffeeeeee), width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '환불규정',
            style: TextStyles.black14BoldTextStyle,
          ),
          Html(
            data: orderInfo
                .options[index].orderProduct.product.productContent['refund'],
            style: <String, Style>{
              'body': Style(
                margin: const EdgeInsets.all(0),
              ),
              'p': Style(
                fontSize: FontSize(
                    14.0 * MediaQuery.of(context).textScaleFactor.round()),
                fontHeight: 1.0,
              )
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = orderInfo.options[index].orderProduct.state;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 40,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0.0,
        title: const HeaderTitleWidget(title: '사용자 정보'),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserInfoWidget(title: '예약자 정보', fields: orderInfo.fields),
              if (orderInfo.options[index].each.isNotEmpty)
                Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: UserInfoListWidget(
                        title: '사용자 정보', each: orderInfo.options[index].each))
              else
                Container(),
              Container(
                margin: const EdgeInsets.only(top: 48),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '8데이즈+ 고객 센터',
                        style: TextStyles.black20BoldTextStyle,
                      ),
                      const CustomerCenterWidget(),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: _buildRefundPolicy(context),
              ),
              if (state == 'COMPLETE_REFUND' || state == 'REQUEST_REFUND')
                Container()
              else
                SafeArea(
                    child: Container(
                  margin: const EdgeInsets.only(top: 48),
                  width: 312 * DeviceRatio.scaleWidth(context),
                  child: WhiteButtonWidget(
                    title: '환불하기',
                    onPressed: () {
                      AppRoutes.createRefundPage(
                          context, orderCode, orderInfo.options[index]);
                    },
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
