import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';




class ProductStateWidget extends StatelessWidget {
  const ProductStateWidget({this.productModel});

  final OrderInfoProductModel productModel;

  @override
  Widget build(BuildContext context) {
    String state;
    Color textColor; //text 와 border 색깔 미세하게 다름
    Color borderColor;
    switch (productModel.state) {
      case 'PENDING_PAYMENT':
        state = ReservationPageStrings.pendingPayment;
        textColor = const Color(0xffff7500);
        borderColor = const Color(0xffff9e4c);
        break;
      case 'COMPLETE_PAYMENT':
        state = ReservationPageStrings.completePayment;
        textColor = const Color(0xffff7500);
        borderColor = const Color(0xffff9e4c);
        break;
      case 'PENDING_RESERVE':
        state = ReservationPageStrings.pendingReserve;
        textColor = const Color(0xffff7500);
        borderColor = const Color(0xffff9e4c);
        break;
      case 'COMPLETE_RESERVE':
        state = ReservationPageStrings.completeReserve;
        textColor = const Color(0xffff7500);
        borderColor = const Color(0xffff9e4c);
        break;
      case 'REQUEST_REFUND':
        state = ReservationPageStrings.requestRefund;
        textColor = const Color(0xff909090);
        borderColor = const Color(0xff909090);
        break;
      case 'PENDING_REFUND':
        state = ReservationPageStrings.pendingRefund;
        textColor = const Color(0xff909090);
        borderColor = const Color(0xff909090);
        break;
      case 'COMPLETE_REFUND':
        state = ReservationPageStrings.completeRefund;
        textColor = const Color(0xff909090);
        borderColor = const Color(0xff909090);
        break;
      case 'CANCEL_RESERVE':
        state = ReservationPageStrings.cancelReserve;
        textColor = const Color(0xff909090);
        borderColor = const Color(0xff909090);
        break;
      case 'COMPLETE_USE':
        state = ReservationPageStrings.completeUse;
        textColor = const Color(0xff909090);
        borderColor = const Color(0xff909090);
        break;
      default:
    }
    return Container(
      height: 20,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(
        bottom: 6,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Container(
        child: Center(
          child: Text(
            state,
            style: TextStyle(fontSize: 10, color: textColor),
          ),
        ),
      ),
    );
  }
}
