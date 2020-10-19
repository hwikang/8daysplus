import 'package:flutter/material.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';

class OrderDateTimeWidget extends StatelessWidget {
  const OrderDateTimeWidget({
    this.orderDate,
    this.orderCode,
  });

  final String orderCode;
  final String orderDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 24),
      height: 80 * DeviceRatio.scaleRatio(context),
      color: const Color(0xff404040),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${ReservationPageStrings.orderDate} $orderDate',
              style: TextStyles.white18BoldTextStyle,
            ),
            Text('${ReservationPageStrings.barcodeOrderDate} $orderCode',
                style: TextStyles.white12TextStyle),
          ]),
    );
  }
}
