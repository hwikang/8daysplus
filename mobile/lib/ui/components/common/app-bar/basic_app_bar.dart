import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../header_title_widget.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppBar({this.showLeading = true, this.title = ''});

  final bool showLeading;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        color: Colors.black,
        onPressed: () {
          AppRoutes.pop(context);
        },
      ),
      title: HeaderTitleWidget(title: title),
    );
  }
}
