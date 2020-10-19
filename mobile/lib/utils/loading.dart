import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {
  static Widget loadingBounce() => SpinKitThreeBounce(
        color: Colors.black,
        size: 25.0,
      );
}
