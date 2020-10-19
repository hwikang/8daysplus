import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/text_styles.dart';

class DiscoveryRootTab extends StatelessWidget {
  const DiscoveryRootTab({this.tabController});

  final TabController tabController;

  // final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final categoryBloc = Provider.of<CategoryBloc>(context);
    final List<Widget> tabs = categoryBloc.repoList.value.map((rootModel) {
      return Tab(text: rootModel.name);
    }).toList();

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 24),
      child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelPadding: const EdgeInsets.only(right: 16),
          labelStyle: TextStyles.black20BoldTextStyle,
          labelColor: const Color(0xff404040),
          unselectedLabelStyle: TextStyles.grey20TextStyle,
          unselectedLabelColor: Colors.grey,
          tabs: tabs),
    );
  }
}
