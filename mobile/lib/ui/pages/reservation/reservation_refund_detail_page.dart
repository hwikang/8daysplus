import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/customer_center_widget.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/product-order/payment_price_widget.dart';
import '../../components/common/product-order/reservation_product_widget.dart';
import '../../components/common/user/user_info_widget.dart';

class ReservationRefundDetailPage extends StatelessWidget {
  const ReservationRefundDetailPage({
    this.product,
  });

  final OrderInfoProductModel product;

  Widget _buildRefundDateAndReason(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ReservationPageStrings.refundDetail_dateAndReason,
            style: TextStyles.black20BoldTextStyle),
        UserInfoRow(
            field: ReservationPageStrings.refundDetail_date,
            value: product.orderRefund.cancelDate),
        UserInfoRow(
            field: ReservationPageStrings.refundDetail_reason,
            value: product.orderRefund.reason),
      ],
    );
  }

  Widget _buildRefundProductDetail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ReservationPageStrings.refundDetail_product,
            style: TextStyles.black20BoldTextStyle),
        const SizedBox(
          height: 16,
        ),
        ReservationProductWidget(
          productModel: product,
          showState: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(product.orderRefund.refundPrice);
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
        title: const HeaderTitleWidget(
            title: ReservationPageStrings.refundDetail_title),
        titleSpacing: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: <Widget>[
              _buildRefundDateAndReason(context),
              const SizedBox(
                height: 48,
              ),
              _buildRefundProductDetail(context),
              const SizedBox(
                height: 48,
              ),
              PaymentPriceWidget(
                  title: ReservationPageStrings.refundDetail_info,
                  isRefund: true,
                  totalPrice: product.orderRefund.refundPrice -
                      product.orderRefund.refundPointPrice,
                  totalPriceText:
                      ReservationPageStrings.refundDetail_totalPrice,
                  totalDiscountText:
                      ReservationPageStrings.refundDetail_totalDiscountPrice,
                  payAmountText:
                      ReservationPageStrings.refundDetail_refundPrice,
                  usedCouponPrice: product.orderRefund.refundCouponPrice,
                  usedLifePoint: product.orderRefund.refundPointPrice,
                
                  payAmount: product.orderRefund.refundPrice),
              const SizedBox(
                height: 24,
              ),
              Container(
                // height: 80,
                width: 312 * DeviceRatio.scaleWidth(context),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffeeeeee), width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text(
                    ReservationPageStrings.refundDetail_refundNotice,
                    style: TextStyles.grey14TextStyle,
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const CustomerCenterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
