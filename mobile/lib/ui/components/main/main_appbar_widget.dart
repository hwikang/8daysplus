import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/assets.dart';
import '../../../utils/routes.dart';
import '../../pages/main/main_alarm_page.dart';

class MainAppbarWidget extends StatelessWidget {
  const MainAppbarWidget({this.showCartIcon = false});

  final bool showCartIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 16),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              final navbarBloc = Provider.of<NavbarBloc>(context);
              navbarBloc.mainDoubleTap(context);
            },
            child: Image(
              image: AssetImage(ImageAssets.logoImage),
              width: 79,
              height: 29,
            ),
          ),
          Expanded(child: Container()),
          if (showCartIcon)
            GestureDetector(
              onTap: () {
                AppRoutes.cartListPage(context);
              },
              child: Image.asset(
                ImageAssets.bagImage,
                width: 40,
              ),
            )
          else
            Container(),
          GestureDetector(
            onTap: () {
              AppRoutes.push(context, MainAlarmPage());
            },
            child: Container(
              child: Image(
                image: AssetImage(ImageAssets.alertOffImage),
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
