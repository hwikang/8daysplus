import 'package:flutter/material.dart';

import '../../../../utils/debouncer.dart';
import '../../../../utils/text_styles.dart';
import '../loading_widget.dart';

class BlackButtonWidget extends StatelessWidget {
  const BlackButtonWidget({
    this.title = '확인',
    this.onPressed,
    this.isUnabled = false,
    this.isLoading = false,
    // this.debouncer
  });

  final bool isLoading;
  final bool isUnabled;
  final Function onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 250);
    return Container(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color:
                isUnabled ? const Color(0xfff4f4f4) : const Color(0xff313537),
            borderRadius: BorderRadius.circular(4)),
        child: FlatButton(
          onPressed: isUnabled || isLoading
              ? () {}
              : () {
                  debouncer.run(onPressed);
                },
          child: isLoading
              ? const LoadingWidget(
                  brightness: Brightness.dark,
                )
              : Text(
                  title,
                  style: isUnabled
                      ? TextStyle(
                          fontFamily: FontFamily.bold,
                          fontSize: 14,
                          color: const Color(0xffd0d0d0),
                        )
                      : TextStyles.white14BoldTextStyle,
                ),
        ),
      ),
    );
  }
}
