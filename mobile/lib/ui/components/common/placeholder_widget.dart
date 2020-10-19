import 'package:flutter/material.dart';

import '../../../utils/assets.dart';

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        ImageAssets.placeholderImage,
        fit: BoxFit.contain,
      ),
    );
  }
}
