import 'package:flutter/material.dart';

import '../../../../utils/debouncer.dart';
import '../../../../utils/text_styles.dart';
import '../loading_widget.dart';

class WhiteButtonWidget extends StatelessWidget {
  const WhiteButtonWidget(
      {this.title = '',
      this.titleStyle,
      this.onPressed,
      this.isUnabled = false,
      this.isLoading = false,
      this.height = 48.0});

  final double height;
  final bool isLoading;
  final bool isUnabled;
  final Function onPressed;
  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 400);

    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color:
                isUnabled ? const Color(0xffeeeeee) : const Color(0xffd0d0d0),
          ),
          borderRadius: BorderRadius.circular(4)),
      child: FlatButton(
        onPressed: isUnabled || isLoading
            ? () {}
            : () {
                print('debounce');
                debouncer.run(onPressed);
              },
        child: isLoading
            ? const LoadingWidget()
            : Text(
                title,
                style: isUnabled
                    ? TextStyle(
                        fontFamily: FontFamily.bold,
                        fontSize: 14,
                        color: const Color(0xffd0d0d0),
                      )
                    : titleStyle ?? TextStyles.black14BoldTextStyle,
              ),
      ),
    );
  }
}
