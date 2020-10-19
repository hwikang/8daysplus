import 'package:flutter/material.dart';

import '../../../utils/assets.dart';

class CircularCheckBoxWiget extends StatelessWidget {
  const CircularCheckBoxWiget({
    this.isAgreed = false,
  });

  final bool isAgreed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.only(right: 6),
        child: isAgreed
            ? Image.asset(ImageAssets.cehckOnBlackImage)
            : Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xffe0e0e0), width: 1)),
              ));
  }
}
