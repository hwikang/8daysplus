import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../../components/common/header_title_widget.dart';

class ReservationBarcodePage extends StatelessWidget {
  const ReservationBarcodePage(
      {this.order, this.orderProduct, this.orderInfo, this.index});

  final int index;
  final OrderListViewModel order; //detail
  final CreateOrderInputModel orderInfo; // refund 에필요
  final OrderInfoProductModel orderProduct; // 상품상세

  Widget _buildDetailContainer(BuildContext context) {
    String state;
    Color stateColor;
    switch (orderProduct.state) {
      case 'COMPLETE_PAYMENT':
        state = ReservationPageStrings.barcodeUnused;
        stateColor = const Color(0xffff7500);
        break;
      case 'COMPLETE_USE':
        state = ReservationPageStrings.barcodeUsed;
        stateColor = const Color(0xff404040);
        break;

      default:
        state = ReservationPageStrings.barcodeUnused;
    }
    return Container(
      margin: const EdgeInsets.only(
        top: 14,
        left: 24,
        right: 24,
      ),
      child: Column(
        children: <Widget>[
          buildDetailRow(
              context: context,
              field: ReservationPageStrings.barcodeOrderDate,
              value: order.orderDate),
          buildDetailRow(
              context: context,
              field: ReservationPageStrings.barcodeOrderCode,
              value: order.orderCode),
          buildDetailRow(
              context: context,
              field: ReservationPageStrings.barcodeOrderState,
              value: state,
              valueColor: stateColor),
          buildDetailRow(
              context: context,
              field: ReservationPageStrings.barcodeProductName,
              value: orderProduct.product.name),
          buildDetailRow(
              context: context,
              field: ReservationPageStrings.barcodeExpiryDate,
              value: orderProduct.reserveDate),
        ],
      ),
    );
  }

  Widget buildDetailRow(
      {BuildContext context, String field, String value, Color valueColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            margin: const EdgeInsets.only(right: 30),
            child: Text(
              field,
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Container(
            width: 228,
            child: Text(
              value,
              style: valueColor == null
                  ? TextStyles.black14TextStyle
                  : TextStyle(
                      fontFamily: FontFamily.regular,
                      color: valueColor,
                      fontSize: 14,
                    ),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBarcodeContainer() {
    var isUsed = false;
    if (orderProduct.state == 'COMPLETE_USE') {
      isUsed = true;
    }

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffe0e0e0)))),
      child: Column(
        children: <Widget>[
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Color(
                            int.parse(orderProduct.voucher.templete.color)),
                        width: 4.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.network(orderProduct.voucher.templete.left.url,
                    height: 25),
                Image.network(orderProduct.voucher.templete.right.url,
                    height: 25),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Stack(children: <Widget>[
              CachedNetworkImage(
                imageUrl: orderProduct.product.image.url,
                height: 180,
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    color: const Color(0xfff8f8f8)
                        .withOpacity(isUsed ? 0.79 : 0.0)),
                child: Center(
                  child: Text(
                    isUsed ? ReservationPageStrings.barcodeUsed : '',
                    style: TextStyle(
                      fontFamily: FontFamily.bold,
                      color: const Color(0xff606060),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: BarCodeImage<BarCodeParams>(
                    params: Code128BarCodeParams(
                      orderProduct.voucher.barcode,
                      lineWidth:
                          1.3, // width for a single black/white bar (default: 2.0)
                      barHeight:
                          56.0, // height for the entire widget (default: 100.0)
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 24),
                  child: Text(
                    orderProduct.voucher.barcode,
                    style: TextStyles.black10TextStyle,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        titleSpacing: 0.0,
        title:
            const HeaderTitleWidget(title: ReservationPageStrings.barcodeTitle),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildBarcodeContainer(),
            _buildDetailContainer(context),
          ],
        ),
      ),
    );
  }
}
