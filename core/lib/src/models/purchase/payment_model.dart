import 'dart:convert';

import '../../../core.dart';

class PaymentModel {
  PaymentModel(
      {this.totalPrice = 0,
      this.usedCoupons = const <AppliedCouponModel>[],
      this.usedWelfarePoint = 0,
      this.usedLifePoint = 0,
      this.usedCouponPrice = 0,
      this.paymentType = 'CREDITCARD',
      this.cardHolderType = 'PERSONAL',
      this.cardCode = 0});

  int cardCode;
  String cardHolderType;
  int payAmount;
  String paymentType;
  int totalPrice;
  int usedCouponPrice;
  List<AppliedCouponModel> usedCoupons;
  int usedLifePoint;
  int usedWelfarePoint;

  int getPayAmount() {
    print('totalPrice $totalPrice');

    print('usedCouponPrice $usedCouponPrice');

    print('usedLifePoint $usedLifePoint');

    return totalPrice - usedCouponPrice - usedLifePoint;
  }

  Map<String, dynamic> toJson() {
    final usedCouponsMap = usedCoupons.map((usedCounpon) {
      return usedCounpon.toJson();
    }).toList();
    return <String, dynamic>{
      'lifePoint': usedLifePoint,
      'welfarePoint': usedWelfarePoint,
      'totalPrice': getPayAmount(),
      'paymentType': paymentType,
      'cardHolderType': cardHolderType,
      'cardCode': json.encode(cardCode.toString()),
      'coupons': usedCouponsMap
    };
  }
}

class AppliedCouponModel {
  const AppliedCouponModel(
      {this.orderItemCode,
      this.couponId,
      this.discountPrice,
      this.reserveDate});

  final String couponId;
  final int discountPrice;
  final String orderItemCode;
  final String reserveDate; //같은상품 다른날 주문시 구별하기위해필요

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'orderItemCode': json.encode(orderItemCode),
      'couponId': json.encode(couponId),
      'discountPrice': discountPrice,
    };
  }
}

class CreditCardModel {
  CreditCardModel({
    this.name,
    this.cardCode,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(cardCode: json['code'], name: json['name']);
  }

  final int cardCode;
  final String name;
}

class PaymentMethodModel {
  PaymentMethodModel({
    this.coverImage,
    this.type,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
        type: json['type'],
        coverImage: ImageViewModel.fromJson(json['coverImage']));
  }

  final ImageViewModel coverImage;
  final String type;
}
