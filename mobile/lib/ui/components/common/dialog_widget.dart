import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';

class DialogWidget {
  static void buildDialog(
      {@required BuildContext context,
      Function onPressed,
      @required String title,
      String subTitle1 = '',
      String buttonTitle = CommonTexts.confirmButton}) {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false, // user must tap button!
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title ?? '',
              style: TextStyles.black16BoldTextStyle,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    subTitle1,
                    style: TextStyles.grey14TextStyle,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    buttonTitle,
                    style: TextStyles.black14BoldTextStyle,
                  ),
                  onPressed: onPressed ??
                      () {
                        Navigator.of(context).pop();
                      }),
            ],
          );
        });
  }

  static void buildTwoButtonDialog(
      {@required BuildContext context,
      Function onPressed1,
      Function onPressed2,
      String title = '',
      String subTitle1 = '',
      String buttonTitle1 = '',
      String buttonTitle2 = ''}) {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false, // user must tap button!
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyles.grey14TextStyle,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(subTitle1),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    buttonTitle1,
                    style: TextStyles.black14BoldTextStyle,
                  ),
                  onPressed: onPressed1 ??
                      () {
                        Navigator.of(context).pop();
                      }),
              FlatButton(
                  child: Text(
                    buttonTitle2,
                    style: TextStyles.black14BoldTextStyle,
                  ),
                  onPressed: onPressed2 ??
                      () {
                        Navigator.of(context).pop();
                      }),
            ],
          );
        });
  }

  static void showAlert({
    BuildContext context,
    Widget child,
  }) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: child,
        duration: const Duration(seconds: 1),
      ));
  }
}
