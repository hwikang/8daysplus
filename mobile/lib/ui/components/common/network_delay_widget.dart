import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import 'button/white_button_widget.dart';

class NetworkDelayPage extends StatelessWidget {
  const NetworkDelayPage({
    this.retry,
  });

  final Function retry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ErrorTexts.networkError,
                  textAlign: TextAlign.center,
                  style: TextStyles.grey16TextStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                if (retry != null)
                  WhiteButtonWidget(
                    title: '새로고침',
                    onPressed: retry,
                  )
              ]),
        ),
      ),
    );
  }
}

class NetworkDelayWidget extends StatelessWidget {
  const NetworkDelayWidget({
    this.retry,
  });

  final Function retry;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      margin: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                ErrorTexts.networkError,
                textAlign: TextAlign.center,
                style: TextStyles.grey16TextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              if (retry != null)
                WhiteButtonWidget(
                  title: '새로고침',
                  onPressed: retry,
                )
            ]),
      ),
    );
  }
}
