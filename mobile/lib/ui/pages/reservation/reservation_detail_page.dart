import 'package:core/core.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/html_parser.dart';
import 'package:html_widget/style.dart';
import 'package:mobile/ui/components/common/network_delay_widget.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_styles.dart';
import '../../components/common/customer_center_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/list_style_text_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../components/common/product-order/order_date_time_widget.dart';
import '../../components/common/product-order/reservation_product_widget.dart';
import '../../components/common/user/user_info_widget.dart';

class ReservationDetailPage extends StatelessWidget {
  ReservationDetailPage({this.orderCode, this.orderInfoIndex});

  final String orderCode;
  final OrderDetailProvider orderDetailProvider = OrderDetailProvider();
  final int orderInfoIndex;

  @override
  Widget build(BuildContext context) {
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
        title: const HeaderTitleWidget(title: '예약 상세'),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Provider<OrderDetailBloc>(
          create: (context) => OrderDetailBloc(orderCode: orderCode),
          child: ReservationDetailBody(orderInfoIndex: orderInfoIndex)),

      // FutureBuilder<OrderListViewModel>(
      //   future: orderDetailProvider.order(orderCode),
      //   builder: (context, orderSnapshot) {
      //     if (!orderSnapshot.hasData) {
      //       return const LoadingWidget();
      //     }
      //     return SingleChildScrollView(
      //       child: Container(
      //           child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: <Widget>[
      //           OrderDateTimeWidget(
      //             orderCode: orderSnapshot.data.orderCode,
      //             orderDate: orderSnapshot.data.orderDate,
      //           ),
      //           ReservationDetailBody(
      //               orderInfo: orderSnapshot.data.orderInfo,
      //               orderInfoIndex: orderInfoIndex)
      //         ],
      //       )),
      //     );
      //   },
      // ),
    );
  }
}

class ReservationDetailBody extends StatelessWidget {
  const ReservationDetailBody(
      {
      // this.orderInfo,
      this.orderInfoIndex});

  // final CreateOrderInputModel orderInfo;
  final int orderInfoIndex;

  Widget _buildRefundPolicy(String refundHtml) {
    // final String refundHtml = orderInfo
    //     .options[orderInfoIndex].orderProduct.product.productContent['refund'];
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
    return StreamBuilder<OrderListViewModel>(
      stream: Provider.of<OrderDetailBloc>(context).orderDetail,
      builder: (context, orderSnapshot) {
        switch (orderSnapshot.connectionState) {
          case ConnectionState.waiting:
            return LoadingWidget();
            break;
          default:
            if (orderSnapshot.hasError) {
              return NetworkDelayWidget(
                  retry: Provider.of<OrderDetailBloc>(context).fetch);
            }

            final orderInfo = orderSnapshot.data.orderInfo;
            return SingleChildScrollView(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderDateTimeWidget(
                    orderCode: orderSnapshot.data.orderCode,
                    orderDate: orderSnapshot.data.orderDate,
                  ),
                  Container(
                      margin: const EdgeInsets.all(24),
                      child: Column(children: <Widget>[
                        ReservationProductWidget(
                          productModel:
                              orderInfo.options[orderInfoIndex].orderProduct,
                          showState: true,
                        ),
                        ReservationDetailUser(
                          orderInfo: orderInfo,
                        ),
                        _buildRefundPolicy(orderInfo.options[orderInfoIndex]
                            .orderProduct.product.productContent['refund']),
                        Container(
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
                      ])),
                  // ReservationDetailBody(
                  //     orderInfo: orderSnapshot.data.orderInfo,
                  //     orderInfoIndex: orderInfoIndex)
                ],
              )),
            );
        }
      },
    );
  }
}

class ReservationDetailUser extends StatelessWidget {
  const ReservationDetailUser({this.orderInfo});

  final CreateOrderInputModel orderInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserInfoWidget(title: '예약자 정보', fields: orderInfo.fields),
          Container(
              margin: const EdgeInsets.only(top: 48),
              child: UserInfoListWidget(
                  title: '사용자 정보', each: orderInfo.options[0].each))
        ],
      ),
    );
  }
}
