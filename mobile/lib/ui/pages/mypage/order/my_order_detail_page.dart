import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/ui/components/common/network_delay_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/button/white_button_widget.dart';
import '../../../components/common/loading_widget.dart';
import '../../../components/common/product-order/order_date_time_widget.dart';
import '../../../components/common/product-order/payment_price_widget.dart';
import '../../../components/common/product-order/reservation_product_widget.dart';

class MyOrderDetailPage extends StatelessWidget {
  MyOrderDetailPage({this.orderCode});

  final String orderCode;

  @override
  Widget build(BuildContext context) {
    // final orderDetailBloc = OrderDetailBloc(orderCode: orderCode);
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
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Provider<OrderDetailBloc>(
          create: (context) => OrderDetailBloc(orderCode: orderCode),
          child: MyOrderDetailBody(),
        ));
  }
}

class MyOrderDetailBody extends StatelessWidget {
  const MyOrderDetailBody({Key key}) : super(key: key);

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
                  retry: () => {Provider.of<OrderDetailBloc>(context).fetch()});
            }

            final orderModel = orderSnapshot.data;

            return SingleChildScrollView(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderDateTimeWidget(
                    orderCode: orderModel.orderCode,
                    orderDate: orderModel.orderDate,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderModel.orderInfo.options.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              child: ReservationProductWidget(
                                productModel: orderModel
                                    .orderInfo.options[index].orderProduct,
                                showState: true,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: VoucherUserInfoButton(
                                orderModel: orderModel,
                                orderInfo: orderModel.orderInfo,
                                index: index,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24 * MediaQuery.of(context).textScaleFactor,
                        bottom: 48 * MediaQuery.of(context).textScaleFactor),
                    child: PaymentPriceWidget(
                      title: '결제정보',
                      payAmountText: MyPageStrings.orderDetail_payAmountText,
                      totalPriceText: MyPageStrings.orderDetail_totalPriceText,
                      totalDiscountText:
                          MyPageStrings.orderDetail_totalDiscountText,
                      paymentMethod: orderModel.paymentMethod,
                      totalPrice: orderModel.orderPrice,
                      usedCouponPrice: orderModel.couponPrice,
                      usedLifePoint: orderModel.pointPrice,
                      payAmount: orderModel.paymentPrice,
                    ),
                  ),
                  _buildRefundInfo(context, orderModel),
                ],
              )),
            );
        }
      },
    );
  }

  Widget _buildRefundInfo(BuildContext context, OrderListViewModel orderModel) {
    final formatter = NumberFormat('#,###');

    final orderedProducts = orderModel.orderInfo.options;
    var refundPrice = 0; //환불 총가격(결제금액+포인트)
    // int refundCash = 0;
    var refundPoint = 0;
    var refundCoupon = 0;
    orderedProducts.map((option) {
      refundPrice += option.orderProduct.orderRefund.refundPrice;
      refundCoupon += option.orderProduct.orderRefund.refundCouponPrice;
      refundPoint += option.orderProduct.orderRefund.refundPointPrice;
    }).toList();

    // refundCash = refundPrice - refundPoint - refundCoupon;

    if (refundPrice + refundCoupon + refundPoint <= 0) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24 * MediaQuery.of(context).textScaleFactor,
              bottom: 48 * MediaQuery.of(context).textScaleFactor),
          child: PaymentPriceWidget(
            isRefund: true,
            title: ReservationPageStrings.refundDetail_info,
            totalPrice: refundPrice - refundPoint,
            usedCouponPrice: refundCoupon,
            usedLifePoint: refundPoint,
            paymentMethod: orderModel.paymentMethod,
            totalPriceText: ReservationPageStrings.refundDetail_totalPrice,
            totalDiscountText:
                ReservationPageStrings.refundDetail_totalDiscountPrice,
            payAmountText: ReservationPageStrings.refundDetail_refundPrice,
            payAmount: refundPrice,
          ),
        ),
        Container(
          // height: 84 * MediaQuery.of(context).textScaleFactor,
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 28,
            bottom: 34,
          ),
          color: const Color(0xfffafafa),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('최종 결제 금액', style: TextStyles.black20BoldTextStyle),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('신용카드', style: TextStyles.black14BoldTextStyle),
                    Text(
                      '${formatter.format(orderModel.paymentPrice - (refundPrice - refundPoint))}원',
                      style: TextStyles.black16BoldTextStyle,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('8DAYS+포인트', style: TextStyles.black14BoldTextStyle),
                    Text(
                      '${formatter.format(orderModel.pointPrice - refundPoint)}원',
                      style: TextStyles.black16BoldTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class VoucherUserInfoButton extends StatelessWidget {
  const VoucherUserInfoButton({this.orderModel, this.orderInfo, this.index});

  final int index;
  final CreateOrderInputModel orderInfo;
  final OrderListViewModel orderModel; //바우처확인 때문에부름

  Widget _buildVoucherUserButton({
    @required BuildContext context,
    bool unable = false,
    bool showRefundButton = true,
    @required String blackButtonTitle,
    @required OrderInfoProductModel productModel,
    @required Function onBlackButtonClick,
    @required int index,
    String orderCode,
  }) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: const Color(0xffd0d0d0), width: 1)),
                child: FlatButton(
                    child: Text(
                      '사용자 정보 확인',
                      style: TextStyles.black14BoldTextStyle,
                    ),
                    onPressed: () {
                      // orderModel.orderCode
                      AppRoutes.myOrderDetailUserPage(
                        context,
                        orderInfo,
                        orderModel.orderCode,
                        index,
                      );
                    }),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xff404040),
                      borderRadius: BorderRadius.circular(4)),
                  child: FlatButton(
                      child: Text(
                        blackButtonTitle,
                        style: unable
                            ? TextStyles.grey14TextStyle
                            : TextStyles.white14BoldTextStyle,
                      ),
                      onPressed: unable ? null : onBlackButtonClick)),
            ),
          ],
        ),
        if (showRefundButton)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 312 * DeviceRatio.scaleWidth(context),
            height: 48,
            child: WhiteButtonWidget(
              title: '환불',
              onPressed: () {
                AppRoutes.createRefundPage(
                    context, orderCode, orderInfo.options[index]);
              },
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    //상황에 따라 다르게 버튼 생성
    print(
        'voucher type in order detail ${orderInfo.options[index].orderProduct.voucherType}');
    switch (orderInfo.options[index].orderProduct.voucherType) {
      case 'VoucherUrlPath': //바우처타입

        switch (orderInfo.options[index].orderProduct.state) {
          case 'PENDING_RESERVE':
          case 'COMPLETE_PAYMENT':
            button = _buildVoucherUserButton(
                context: context,
                unable: false,
                blackButtonTitle: '바우처 발급중',
                productModel: orderInfo.options[index].orderProduct,
                index: index,
                showRefundButton: true,
                orderCode: orderModel.orderCode,
                onBlackButtonClick: () {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('바우처 발급 중입니다.  처리가 완료되면 안내해 드리겠습니다.'),
                  ));
                });
            break;

          case 'COMPLETE_RESERVE':
          case 'COMPLETE_USE':
            button = _buildVoucherUserButton(
                context: context,
                unable: false,
                blackButtonTitle: '바우처 확인',
                productModel: orderInfo.options[index].orderProduct,
                showRefundButton: true,
                orderCode: orderModel.orderCode,
                index: index,
                onBlackButtonClick: () {
                  AppRoutes.reservationVoucherPage(
                    context,
                    index,
                    orderInfo,
                  );
                });

            break;
          case 'REQUEST_REFUND':
            button = _buildVoucherUserButton(
                context: context,
                unable: false,
                blackButtonTitle: '환불 처리 안내',
                productModel: orderInfo.options[index].orderProduct,
                showRefundButton: false,
                index: index,
                onBlackButtonClick: () {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('환불처리 중입니다.  처리가 완료되면 안내해 드리겠습니다.'),
                  ));
                });
            break;
          case 'CANCEL_RESERVE':
          case 'COMPLETE_REFUND':
          case 'PENDING_REFUND':
            button = _buildVoucherUserButton(
                context: context,
                unable: false,
                blackButtonTitle: '환불 처리 안내',
                showRefundButton: false,
                productModel: orderInfo.options[index].orderProduct,
                index: index,
                onBlackButtonClick: () {
                  AppRoutes.reservationRefundDetailPage(
                      context, orderInfo.options[index].orderProduct);
                });
            break;
          default:
            button = Container();
        }
        break;
      case 'VoucherPays': //바코드 타입,
        switch (orderInfo.options[index].orderProduct.state) {
          //결제완료
          case 'PENDING_RESERVE':
          case 'COMPLETE_PAYMENT':
            if (orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT' ||
                orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT_COUPON') {
              button = Container(
                width: 312 * DeviceRatio.scaleWidth(context),
                child: WhiteButtonWidget(
                  title: '환불',
                  onPressed: () {
                    AppRoutes.createRefundPage(context, orderModel.orderCode,
                        orderInfo.options[index]);
                  },
                ),
              );
            } else {
              button = BlackButtonWidget(
                onPressed: () {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('바우처 발급 중입니다.  처리가 완료되면 안내해 드리겠습니다.'),
                  ));
                },
                title: '바우처 발급중',
              );
            }

            break;

          case 'REQUEST_REFUND':
            button = BlackButtonWidget(
              onPressed: () {
                Scaffold.of(context).showSnackBar(const SnackBar(
                  content: Text('환불 처리 중입니다.  처리가 완료되면 안내해 드리겠습니다.'),
                ));
              },
              title: '환불 처리 안내',
            );

            break;
          case 'CANCEL_RESERVE':
          case 'COMPLETE_REFUND':
          case 'PENDING_REFUND':
            button = BlackButtonWidget(
              onPressed: () {
                AppRoutes.reservationRefundDetailPage(
                  context,
                  orderInfo.options[index].orderProduct,
                );
              },
              title: '환불 처리 안내',
            );
            break;
          case 'COMPLETE_USE':
            if (orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT' ||
                orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT_COUPON') {
              button = Container();
            } else {
              button = Container(
                width: 312 * DeviceRatio.scaleWidth(context),
                child: BlackButtonWidget(
                  onPressed: () {
                    AppRoutes.reservationBarcodePage(
                        context,
                        orderModel,
                        orderInfo.options[index].orderProduct,
                        orderInfo,
                        index);
                  },
                  title: '바코드 보기',
                ),
              );
            }

            break;

          //예약 완료
          default:
            if (orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT' ||
                orderInfo.options[index].orderProduct.product.sourceType ==
                    'EVENT_COUPON') {
              button = Container(
                width: 312 * DeviceRatio.scaleWidth(context),
                child: WhiteButtonWidget(
                  title: '환불',
                  onPressed: () {
                    AppRoutes.createRefundPage(context, orderModel.orderCode,
                        orderInfo.options[index]);
                  },
                ),
              );
            } else {
              button = Column(
                children: <Widget>[
                  Container(
                    width: 312 * DeviceRatio.scaleWidth(context),
                    child: BlackButtonWidget(
                      onPressed: () {
                        AppRoutes.reservationBarcodePage(
                            context,
                            orderModel,
                            orderInfo.options[index].orderProduct,
                            orderInfo,
                            index);
                      },
                      title: '바코드 보기',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: 312 * DeviceRatio.scaleWidth(context),
                    child: WhiteButtonWidget(
                      title: '환불',
                      onPressed: () {
                        AppRoutes.createRefundPage(context,
                            orderModel.orderCode, orderInfo.options[index]);
                      },
                    ),
                  )
                ],
              );
            }
        }

        break;
      default:
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
          top: 16,
        ),
        child: button);
  }
}
