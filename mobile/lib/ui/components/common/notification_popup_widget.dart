import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/text_styles.dart';

class NotificationPopupWidget extends StatefulWidget {
  const NotificationPopupWidget({@required this.title, @required this.body});

  final String body;
  final String title;

  @override
  State<StatefulWidget> createState() =>
      NotificationPopupWidgetState(title: title, body: body);
}

class NotificationPopupWidgetState extends State<NotificationPopupWidget>
    with SingleTickerProviderStateMixin {
  NotificationPopupWidgetState({@required this.title, this.body});

  String body;
  AnimationController controller;
  Animation<Offset> position;
  String title;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticInOut));

    position.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: SlideTransition(
        position: position,
        child: Container(
          width: 336 * DeviceRatio.scaleWidth(context),
          margin: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0x1e000000),
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  spreadRadius: 0),
            ],
          ),
          child: Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyles.black12BoldTextStyle,
                  ),
                  Text(body, style: TextStyles.black12TextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
