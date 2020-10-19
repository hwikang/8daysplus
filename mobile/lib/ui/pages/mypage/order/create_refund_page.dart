import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/html_parser.dart';
import 'package:html_widget/style.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utils/handle_network_error.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/dialog_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/list_style_text_widget.dart';
import '../../../components/common/product-order/reservation_product_widget.dart';
import 'select_refund_reason_page.dart';

class CreateRefundPage extends StatefulWidget {
  const CreateRefundPage({this.orderCode, this.option});

  final OrderInfoOptionsModel option;
  final String orderCode;

  @override
  _CreateRefundPageState createState() => _CreateRefundPageState();
}

class _CreateRefundPageState extends State<CreateRefundPage> {
  bool isLoading;
  String reason;

  @override
  void initState() {
    super.initState();
    reason = '선택';
    isLoading = false;
  }

  Widget _buildRefunPolicy(BuildContext context) {
    final String refundHtml =
        widget.option.orderProduct.product.productContent['refund'];
    if (refundHtml == '<p></p>') {
      return Container();
    }
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xffeeeeee))),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '환불규정',
            style: TextStyles.black14BoldTextStyle,
          ),
          Html(data: refundHtml, customRender: <String, CustomRender>{
            'p': (context, child, attributes, element) {
              // print(element.parent.text);
              // print(element.parent.localName);
              // print(element.children.length);
              print(element.text);
              print(element.localName);

              return ListStyleTextWidget(
                text: element.text,
                style: TextStyles.black14TextStyle,
              );
            },
          }, style: <String, Style>{
            'body': Style(
              margin: const EdgeInsets.all(0),
            ),
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    Analytics.analyticsScreenName('Mypage_Purchase_Refunded');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          title: const HeaderTitleWidget(title: '환불하기'),
        ),
        bottomNavigationBar: SafeArea(
            child: Container(
                height: 106 * MediaQuery.of(context).textScaleFactor,
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 11 * MediaQuery.of(context).textScaleFactor,
                ),
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffeeeeee)),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '총 1 개',
                          style: TextStyles.black14TextStyle,
                        ),
                        Text(
                          '${formatter.format(widget.option.orderProduct.totalPrice)}원',
                          style: TextStyles.orange16BoldTextStyle,
                        ),
                      ],
                    ),
                    Container(
                        height: 48 * MediaQuery.of(context).textScaleFactor,
                        margin: EdgeInsets.only(
                            top: 8 * MediaQuery.of(context).textScaleFactor),
                        width: MediaQuery.of(context).size.width,
                        child: BlackButtonWidget(
                            title: '환불하기',
                            isLoading: isLoading,
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              final refundModel = CreateRefundModel(
                                  orderCode: widget.orderCode,
                                  orderItemCode:
                                      widget.option.orderProduct.orderItemCode,
                                  reason: reason);

                              print(refundModel.toJson());
                              final createRefundBloc = CreateRefundBloc();
                              createRefundBloc
                                  .createRefund(refundModel)
                                  .then((result) {
                                if (result) {
                                  DialogWidget.buildDialog(
                                      context: context,
                                      title: '환불 요청 완료',
                                      buttonTitle: '확인',
                                      onPressed: () {
                                        AppRoutes.jumpOrderPage(context);
                                      });
                                } else {
                                  DialogWidget.buildDialog(
                                      context: context,
                                      title: '환불 실패',
                                      buttonTitle: '확인',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }).catchError((dynamic error) {
                                logger.w(error);
                                HandleNetworkError.showErrorDialog(
                                    context, error);

                                setState(() {
                                  isLoading = false;
                                });
                              });
                            })),
                  ],
                ))),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              children: <Widget>[
                _buildRefunPolicy(context),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '환불 사유',
                      style: TextStyles.black20BoldTextStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push<String>(
                            context,
                            MaterialPageRoute<String>(
                                builder: (context) =>
                                    SelectRefundReasonPage())).then((data) {
                          if (data != null) {
                            if (data.isNotEmpty) {
                              setState(() {
                                reason = data;
                              });
                            }
                          }

                          print('return data $data');
                        });
                      },
                      child: Container(
                        // height: 48,
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(top: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              reason,
                              style: TextStyles.grey14TextStyle,
                            ),
                            Text('>', style: TextStyles.grey14TextStyle)
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                Container(
                  margin: const EdgeInsets.only(
                    top: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '환불 정보',
                        style: TextStyles.black20BoldTextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: ReservationProductWidget(
                          productModel: widget.option.orderProduct,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  bool isRefundableDate() {
    var testDate = '${widget.option.orderProduct.reserveDate} 24:00:00';
    getLogger(this).i('refundable date is until $testDate');

    var date = DateTime.parse(testDate);
    final res = date.isAfter(DateTime.now());

    return res;
  }
}
