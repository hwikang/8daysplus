import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';

class PaymentPriceWidget extends StatelessWidget {
  const PaymentPriceWidget({
    @required this.title,
    this.payAmount = 0,
    this.payAmountText = '',
    this.paymentMethod = '',
    @required this.totalPrice,
    this.totalPriceText = '',
    this.totalDiscountText = '',
    this.usedCouponPrice = 0,
    this.usedLifePoint = 0,
    this.isRefund = false,
  });

  final bool isRefund; //환불정보
  final int payAmount;
  final String payAmountText;
  final String paymentMethod;
  final String title;
  final String totalDiscountText;
  final int totalPrice;
  final String totalPriceText;
  final int usedCouponPrice;
  final int usedLifePoint;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    String usedLifePointString;
    String usedCouponPriceString;
    String totalDiscountString;
    if (usedLifePoint == 0) {
      usedLifePointString = '0P';
    } else {
      if (isRefund) {
        usedLifePointString = '${formatter.format(usedLifePoint)}P';
      } else {
        usedLifePointString = '-${formatter.format(usedLifePoint)}P';
      }
    }
    if (usedCouponPrice == 0) {
      usedCouponPriceString = '0원';
    } else {
      if (isRefund) {
        usedCouponPriceString =
            '${formatter.format(usedCouponPrice)}원(${MyPageStrings.orderDetail_couponNonRefundable})';
      } else {
        usedCouponPriceString = '-${formatter.format(usedCouponPrice)}원';
      }
    }
    if (usedCouponPrice + usedLifePoint == 0) {
      totalDiscountString = '0원';
    } else {
      if (isRefund) {
        totalDiscountString =
            '${formatter.format(usedCouponPrice + usedLifePoint)}원';
      } else {
        totalDiscountString =
            '-${formatter.format(usedCouponPrice + usedLifePoint)}원';
      }
    }

    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text(title, style: TextStyles.black20BoldTextStyle),
          if (paymentMethod == '')
            Container()
          else
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
                padding: EdgeInsets.symmetric(
                  vertical: 16 * MediaQuery.of(context).textScaleFactor,
                ),
                child: Text(
                  paymentMethod,
                  style: TextStyles.black14TextStyle,
                )),
          Container(
            padding: EdgeInsets.only(
                bottom: 14 * MediaQuery.of(context).textScaleFactor,
                top: 14 * MediaQuery.of(context).textScaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  totalPriceText,
                  style: TextStyles.black14BoldTextStyle,
                ),
                Text('${formatter.format(totalPrice)}원',
                    style: TextStyles.black16BoldTextStyle),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                  top: 14 * MediaQuery.of(context).textScaleFactor),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xffeeeeee)))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        totalDiscountText,
                        style: TextStyles.black14BoldTextStyle,
                      ),
                      Text(
                        totalDiscountString,
                        style: TextStyles.black16BoldTextStyle,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${MyPageStrings.orderDetail_8daysPoint}',
                          style: TextStyles.black12TextStyle,
                        ),
                        Text(
                          usedLifePointString,
                          style: TextStyles.black14TextStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 8 * MediaQuery.of(context).textScaleFactor,
                        bottom: 12 * MediaQuery.of(context).textScaleFactor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${MyPageStrings.orderDetail_coupon}',
                          style: TextStyles.black12TextStyle,
                        ),
                        Text(usedCouponPriceString,
                            style: TextStyles.black14TextStyle),
                      ],
                    ),
                  ),
                ],
              )),
          Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xffeeeeee)))),
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        payAmountText,
                        style: TextStyles.black16BoldTextStyle,
                      ),
                      Text('${formatter.format(payAmount)}원',
                          style: TextStyles.orange20BoldTextStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
