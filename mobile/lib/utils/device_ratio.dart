import 'package:flutter/material.dart';

class DeviceRatio {
  static double scaleRatio(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static double screenWidth(BuildContext context) {
    return getDeviceWidth(context) * MediaQuery.of(context).devicePixelRatio;
  }

  static double screenHeight(BuildContext context) {
    return getDeviceHeight(context) * MediaQuery.of(context).devicePixelRatio;
  }

  static double getDeviceHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final abovePadding = MediaQuery.of(context).padding.top;
    const appBarHeight = 100;
    final leftHeight = screenHeight - abovePadding - appBarHeight;
    return leftHeight;
  }

  static double getDeviceWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width;
  }

  static double scaleHeight(BuildContext context) {
    const designGuideHeight = 640;
    final diff = getDeviceHeight(context) / designGuideHeight;
    return diff;
  }

  static double scaleWidth(BuildContext context) {
    const designGuideWidth = 360;
    final diff = getDeviceWidth(context) / designGuideWidth;
    return diff;
  }

  static double scaleFont(BuildContext context) {
    const designGuideWidth = 360;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final width = getDeviceWidth(context);
    return textScaleFactor / (designGuideWidth / width);
  }

  static double productRatio(BuildContext context, String typeName) {
    return 150 *
        scaleWidth(context) /
        (112 * scaleWidth(context) +
            100 * MediaQuery.of(context).textScaleFactor);
    // if (typeName == 'CONTENT') {
    //   return 150 *
    //       scaleWidth(context) /
    //       (112 * scaleWidth(context) +
    //           98 * MediaQuery.of(context).textScaleFactor);
    // } else {
    //   return 150 *
    //       scaleWidth(context) /
    //       (112 * scaleWidth(context) +
    //           128 * MediaQuery.of(context).textScaleFactor);

    // }
  }

  static double listview(BuildContext context) {
    final diffFactor = 1 - MediaQuery.of(context).textScaleFactor;
    if (diffFactor > 0) {
      return -1 - (diffFactor * 0);
    } else {
      return -1 - (diffFactor * (-100));
    }
  }

  static double slideRatio(BuildContext context) {
    print('textScaleFactor ${MediaQuery.of(context).textScaleFactor}');

    return (1.798 * scaleWidth(context)) +
        ((MediaQuery.of(context).textScaleFactor - 1) / 3);
  }

  static double discoveryRatio(BuildContext context) {
    return (19 * scaleWidth(context)) +
        ((MediaQuery.of(context).textScaleFactor - 1) * 10);
  }
}
