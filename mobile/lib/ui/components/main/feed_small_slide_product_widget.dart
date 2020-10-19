import 'package:flutter/material.dart';

import '../common/product-list/list_title_widget.dart';
import '../common/product-list/small_slide_widget.dart';

class FeedSmallSlideProductWidget extends StatelessWidget {
  const FeedSmallSlideProductWidget({
    this.node,
  });

  final Map<String, dynamic> node;

  @override
  Widget build(BuildContext context) {
    if (node['feedSmallSlideProducts'].isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          children: <Widget>[
            ListTitleWidget(
              title: node['title'],
            ),
            const SizedBox(height: 14),
            SmallSlideWidget(
              list: node['feedSmallSlideProducts'],
              labelType: node['labelType'],
            ),
          ],
        ));
  }
}
