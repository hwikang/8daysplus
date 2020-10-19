import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import 'product_state_widget.dart';

class ReservationProductWidget extends StatelessWidget {
  const ReservationProductWidget({this.productModel, this.showState = false});

  final OrderInfoProductModel productModel;
  final bool showState;

  Widget _buildReserveDate(
      BuildContext context, OrderInfoProductModel productModel) {
    String reserveDate;
    String timeValue;
    String optionName;

    if (productModel.orderProductOptions.isEmpty ||
        productModel.orderProductOptions[0].timeSlotValue == '') {
      if (productModel.reserveTimeSchedule.name != '') {
        timeValue = '/ ${productModel.reserveTimeSchedule.name}';
      } else {
        timeValue = '';
      }
    } else {
      timeValue = '/ ${productModel.orderProductOptions[0].timeSlotValue}';
    }

    if (productModel.orderProductOptions.isEmpty) {
      optionName = '';
    } else {
      optionName = '${productModel.orderProductOptions[0].optionName}';
    }

    switch (productModel.product.typeName) {
      case 'ECOUPON':
        reserveDate = '${ReservationPageStrings.expiryDate} ${productModel.reserveDate} 까지';
        break;
      default:
        reserveDate = '${ReservationPageStrings.useDate} : ${productModel.reserveDate}';
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (productModel.product.sourceType != 'EVENT' &&
              productModel.product.sourceType != 'EVENT_COUPON')
            Text(
              '$reserveDate $timeValue',
              style: TextStyles.black12TextStyle,
            ),
          const SizedBox(
            height: 4,
          ),
          Text(
            optionName,
            style: TextStyles.black13TextStyle,
          ),
        ],
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
    );
  }

  Widget _buildOptionText(OrderInfoProductModel productModel) {
    final formatter = NumberFormat('#,###');
    if (productModel.orderProductOptions.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: productModel.orderProductOptions.length,
        itemBuilder: (context, index) {
          final model = productModel.orderProductOptions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 168 * DeviceRatio.scaleWidth(context),
                  margin: const EdgeInsets.only(right: 16),
                  child: Text(
                    '${model.optionItemName}',
                    style: TextStyles.black13TextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${model.amount}개 x ${formatter.format(model.salePrice.floor())}원',
                    style: TextStyles.black13TextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))),
    );
  }

  Widget _buildTotalText(int totalPrice) {
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '총',
            style: TextStyles.black14BoldTextStyle,
          ),
          Text(
            '${formatter.format(totalPrice)} 원',
            style: TextStyles.black14BoldTextStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.productDetailPage(context, productModel.product);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        productModel.product.image.url,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (showState)
                        ProductStateWidget(
                          productModel: productModel,
                        ),
                      Container(
                        width: 228 * DeviceRatio.scaleWidth(context),
                        child: Text(
                          productModel.product.name,
                          style: TextStyles.black14BoldTextStyle,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffeeeeee), width: 1),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                children: <Widget>[
                  _buildReserveDate(context, productModel),
                  _buildOptionText(productModel),
                  _buildTotalText(productModel.totalPrice),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
