import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/assets.dart';
import '../../../../../utils/routes.dart';

class DiscoveryMainHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageBloc = Provider.of<DiscoveryPageBloc>(context);
    final discoveryMainPageBloc = Provider.of<DiscoveryMainPageBloc>(context);

    return Container(
      height: 44,
      margin: const EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
      ),
      child: GestureDetector(
        onTap: () {
          pageBloc.mainModel = discoveryMainPageBloc.model; //save model

          AppRoutes.discoverySearchPage(context);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe0e0e0), width: 1.0),
              borderRadius: BorderRadius.circular(4)),
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              ImageAssets.searchIconImage,
              width: 18,
              height: 19,
            ),
          ),
        ),
      ),
    );
  }
}
