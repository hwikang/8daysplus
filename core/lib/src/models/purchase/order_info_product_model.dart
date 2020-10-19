import 'dart:convert';

import '../../../core.dart';
import '../reservation/order_refund_model.dart';
import '../reservation/voucher_model.dart';
import 'order_product_option_model.dart';

class OrderInfoProductModel {
  OrderInfoProductModel(
      {this.product,
      this.additionalInfo,
      // this.coverImage,
      this.orderItemCode,
      this.cartId,
      // this.id,
      // this.name,
      // this.typeName,
      this.reserveDate,
      this.reserveTimeScheduleId,
      this.reserveTimeSchedule,
      this.state,
      this.totalPrice,
      this.orderProductOptions,
      this.coupons,
      this.orderRefund,
      this.voucher,
      this.voucherType});

  factory OrderInfoProductModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> orderProductJson = json['orderProductOptions'];
    var orderProductOptions = <OrderProductOptionModel>[];
    if (orderProductJson.isNotEmpty) {
      orderProductOptions = orderProductJson.map((dynamic productOption) {
        return OrderProductOptionModel.fromJson(productOption);
      }).toList();
    }

    final List<dynamic> couponsJson = json['coupons'];
    var coupons = <CouponApplyModel>[];
    // print(couponsJson);
    if (couponsJson != null && couponsJson.isNotEmpty) {
      coupons = couponsJson.map((dynamic coupon) {
        // print(coupon);
        return CouponApplyModel.fromJson(coupon);
      }).toList();
    }
    // reserveTimeSchedule;
    var productTimeScheduleModel = ProductTimeScheduleModel();

    if (json['reserveTimeSchedule'] != null) {
      productTimeScheduleModel =
          ProductTimeScheduleModel.fromJson(json['reserveTimeSchedule']);
    }

    return OrderInfoProductModel(
        additionalInfo: json['additionalInfo'],
        product: ProductListViewModel.fromJson(json['product']),
        cartId: json['cartId'],
        orderItemCode: json['orderItemCode'],
        reserveDate: json['reserveDate'],
        state: json['state'],
        totalPrice: json['totalPrice'],
        orderProductOptions: orderProductOptions,
        orderRefund: OrderRefundModel.fromJson(json['orderRefund']),
        coupons: coupons,
        reserveTimeSchedule: productTimeScheduleModel);
  }

  factory OrderInfoProductModel.fromOrderList(Map<String, dynamic> json) {
    final List<dynamic> orderProductJson = json['orderProductOptions'];
    //orderProductOptions
    var orderProductOptions = <OrderProductOptionModel>[];
    if (orderProductJson != null) {
      orderProductOptions = orderProductJson.map((dynamic productOption) {
        return OrderProductOptionModel.fromOrderList(productOption);
      }).toList();
    }

    //coupon
    final List<dynamic> couponsJson = json['coupons'];
    var coupons = <CouponApplyModel>[];
    if (couponsJson != null) {
      coupons = couponsJson.map((dynamic coupon) {
        return CouponApplyModel.fromJson(coupon);
      }).toList();
    }
    //바우처 type 별로 나누기
    var voucher = VoucherModel();
    if (json['voucher'] != null) {
      switch (json['voucherType']) {
        case 'VoucherPays':
          voucher = VoucherModel.fromVoucherPays(json['voucher']);
          break;
        case 'VoucherUrlPath':
          voucher = VoucherModel.fromVoucherUrlPath(json['voucher']);
          break;
        default:
      }
    }

    var productTimeScheduleModel = ProductTimeScheduleModel();

    if (json['reserveTimeSchedule'] != null) {
      productTimeScheduleModel =
          ProductTimeScheduleModel.fromJson(json['reserveTimeSchedule']);
    }
    return OrderInfoProductModel(
      product: json['product'] != null
          ? ProductListViewModel.fromJson(json['product'])
          : ProductListViewModel(),
      additionalInfo: json['additionalInfo'],
      orderItemCode: json['orderItemCode'],
      reserveDate: json['reserveDate'],
      state: json['state'],
      totalPrice: json['totalPrice'],
      orderProductOptions: orderProductOptions,
      coupons: coupons,
      orderRefund: json['orderRefund'] != null
          ? OrderRefundModel.fromJson(json['orderRefund'])
          : OrderRefundModel(),
      voucher: voucher,
      voucherType: json['voucherType'],
      reserveTimeSchedule: productTimeScheduleModel,
    );
  }

  String additionalInfo;
  String cartId;
  List<CouponApplyModel> coupons;
  // ImageViewModel coverImage;
  String id;

  // String name;
  String orderItemCode;

  List<OrderProductOptionModel> orderProductOptions;
  OrderRefundModel orderRefund;
  ProductListViewModel product;
  // String typeName;
  String reserveDate;

  ProductTimeScheduleModel reserveTimeSchedule;
  String reserveTimeScheduleId;
  String state;
  int totalPrice;
  VoucherModel voucher;
  String voucherType;

  Map<String, dynamic> toJson() {
    var orderProductOptionsMap = <Map<String, dynamic>>[];
    if (orderProductOptions != null) {
      orderProductOptionsMap = orderProductOptions.map((orderProductOption) {
        return orderProductOption.toJson();
      }).toList();
    }

    return <String, dynamic>{
      'additionalInfo': json.encode(additionalInfo),
      'reserveDate': json.encode(reserveDate),
      // 'productId': json.encode(productId),
      'cartId': json.encode(cartId ?? ''),
      'orderItemCode': json.encode(orderItemCode ?? ''),
      'product': product.toJsonOnlyId(),
      'orderProductOptions': orderProductOptionsMap,
      'reserveTimeScheduleId': json.encode(reserveTimeScheduleId ?? ''),
    };
  }
}
