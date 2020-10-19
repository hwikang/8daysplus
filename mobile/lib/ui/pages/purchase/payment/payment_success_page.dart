import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/components/common/network_delay_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/singleton.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/loading_widget.dart';
import '../../../components/common/product-order/payment_price_widget.dart';
import '../../../components/common/product-order/reservation_product_widget.dart';
import '../../../components/common/user/user_info_in_box_widget.dart';
import '../../../components/common/user/user_info_widget.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({this.orderCode, this.payAmount});

  final String orderCode;
  final int payAmount;

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Order_Done');
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: const EdgeInsets.only(left: 24),
            child: const HeaderTitleWidget(title: '결제완료')),
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              AppRoutes.firstMainPage(context);
            },
          ),
        ],
      ),
      body: Provider<OrderDetailBloc>(
        create: (context) => OrderDetailBloc(orderCode: orderCode),
        child: PaymentSuccessModule(payAmount: payAmount),
      ),
    );
  }
}

class PaymentSuccessModule extends StatelessWidget {
  const PaymentSuccessModule({this.payAmount});

  final int payAmount;

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
              return NetworkDelayWidget(retry: () {
                Provider.of<OrderDetailBloc>(context).fetch();
              });
            }

            return PaymentSuccessBody(
              orderModel: orderSnapshot.data,
              payAmount: payAmount,
            );
        }
      },
    );
  }
}

class PaymentSuccessBody extends StatelessWidget {
  const PaymentSuccessBody({this.orderModel, this.payAmount});

  final OrderListViewModel orderModel;
  final int payAmount;

  Widget _buildTopContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 320,
      color: const Color(0xff404040),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 61),
            child: Image.asset(
              ImageAssets.payment_success_Image,
              width: 80,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Text(
              '결제가 완료되었습니다',
              style: TextStyles.white20BoldTextStyle,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
            child: Text(
                '예약 상품의 경우 예약 절차에 따라 진행됩니다. 정상적으로 예약이 완료 되면 바우처는 이메일 또는 모바일로 확인 가능합니다.',
                style: TextStyles.white14TextStyle),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var itemName = '';
    var cateName = '';
    var optionName = '';
    var quantity = 0;

    if (orderModel.orderInfo.options.isNotEmpty) {
      itemName = orderModel.orderInfo.options[0].orderProduct.product.name;
      cateName = orderModel.orderInfo.options[0].orderProduct.product.typeName;
      if (orderModel
          .orderInfo.options[0].orderProduct.orderProductOptions.isNotEmpty) {
        optionName = orderModel.orderInfo.options[0].orderProduct
            .orderProductOptions[0].optionName;
        quantity = orderModel
            .orderInfo.options[0].orderProduct.orderProductOptions[0].amount;
      }
    }

    final _analyticsParameter = <String, dynamic>{
      'item_category': cateName,
      'point': orderModel.pointPrice,
      'coupon': orderModel.couponPrice,
      'item_name': itemName,
      'quantity': quantity,
      'item_option_name': optionName,
      'price': orderModel.paymentPrice,
      'item_reservation_date': orderModel.orderDate,
      'payment_info': orderModel.paymentMethod,
      'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
    };
    print(_analyticsParameter.values);
    Analytics.analyticsLogEvent('ecommerce_purchase', _analyticsParameter);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTopContainer(context),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderModel.orderInfo.options.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: UserInfoWidget(
                            title: '예약자 정보',
                            fields: orderModel.orderInfo.fields,
                          ),
                        ),
                        OrderProductListWidget(
                          product:
                              orderModel.orderInfo.options[index].orderProduct,
                        ),
                        UserInfoInBoxWidget(
                          title: '사용자 정보',
                          each: orderModel.orderInfo.options[index].each,
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 48),
                  child: PaymentPriceWidget(
                    title: '결제정보',
                    payAmountText: MyPageStrings.orderDetail_payAmountText,
                    totalPriceText: MyPageStrings.orderDetail_totalPriceText,
                    totalDiscountText:
                        MyPageStrings.orderDetail_totalDiscountText,
                    totalPrice: orderModel.totalPrice,
                    usedCouponPrice: orderModel.couponPrice,
                    usedLifePoint: orderModel.pointPrice,
                    payAmount: orderModel.paymentPrice,
                  ),
                ),
              ],
            ),
          ),
          RouteButton()
        ],
      ),
    );
  }
}

class OrderProductListWidget extends StatelessWidget {
  const OrderProductListWidget({this.product});

  // OrderListViewModel orderModel;
  final OrderInfoProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 48,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('상품정보', style: TextStyles.black20BoldTextStyle),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: ReservationProductWidget(productModel: product),
            ),
          ]),
    );
  }
}

class RouteButton extends StatelessWidget {
  Widget _buildRouteMain(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.firstMainPage(context);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffd0d0d0), width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(
            '다른 액티비티찾기',
            style: TextStyles.black16BoldTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteMyOrder(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.jumpOrderPage(context);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 48,
        decoration: BoxDecoration(
            color: const Color(0xff404040),
            borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text('결제 내역 확인', style: TextStyles.white16BoldTextStyle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70, bottom: 48, left: 24, right: 24),
      child: Column(
        children: <Widget>[
          _buildRouteMain(context),
          _buildRouteMyOrder(context),
        ],
      ),
    );
  }
}
