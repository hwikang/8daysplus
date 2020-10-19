import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/action_link.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/strings.dart';
import '../../pages/my_page.dart';
import '../common/button/white_button_widget.dart';
import '../common/product-list/grid_product_widget.dart';
import '../common/product-list/list_title_widget.dart';

class FeedGridProductWidget extends StatelessWidget {
  const FeedGridProductWidget({
    this.node,
    this.stream,
  });

  final Map<String, dynamic> node;
  final Stream<NetworkState> stream;

  @override
  Widget build(BuildContext context) {
    if (node['feedGridProducts'].isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          children: <Widget>[
            ListTitleWidget(title: node['title']),
            const SizedBox(
              height: 14,
            ),
            GridProductWidget(
                list: node['feedGridProducts'],
                isCount: false,
                labelType: node['labelType'],
                scrollEnded: true),
            if (node['bannerView'])
              Container(
                  margin: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  child: StyleAnalyzeBanner())
            else
              Container(),
            if (node['overView'])
              Container(
                margin: const EdgeInsets.only(
                  top: 28,
                ),
                width: 312 * DeviceRatio.scaleWidth(context),
                child: WhiteButtonWidget(
                  title: CommonTexts.viewMoreButton,
                  onPressed: () {
                    //title에 br 제거
                    final String title = node['title'].replaceAll('<br>', ' ');
                    final actionLinkInstance = ActionLink();
                    final actionLinkModel =
                        ActionLinkModel.fromJson(node['actionLink']);
                    actionLinkInstance.handleActionLink(
                        context, actionLinkModel, title);
                  },
                ),
              )
            else
              Container(),
            // StreamBuilder<NetworkState>(
            //   stream: stream,
            //   builder: (context, stateSnapshot) {
            //     if (stateSnapshot.data == NetworkState.Retry) {
            //       return Container(
            //           margin: const EdgeInsets.symmetric(horizontal: 24),
            //           child: ShimmerGrid());
            //     } else {
            //       return AnimatedOpacity(
            //         opacity:
            //             stateSnapshot.data == NetworkState.Changing ? 0.0 : 1.0,
            //         duration: const Duration(milliseconds: 200),
            //         child: Column(
            //           children: <Widget>[
            //             GridProductWidget(
            //                 list: node['feedGridProducts'],
            //                 isCount: false,
            //                 labelType: node['labelType'],
            //                 scrollEnded: true),
            //             if (node['bannerView'])
            //               Container(
            //                   margin: const EdgeInsets.only(
            //                     left: 24,
            //                     right: 24,
            //                   ),
            //                   child: StyleAnalyzeBanner())
            //             else
            //               Container(),
            //             if (node['overView'])
            //               Container(
            //                 margin: const EdgeInsets.only(
            //                   top: 28,
            //                 ),
            //                 width: 312 * DeviceRatio.scaleWidth(context),
            //                 child: WhiteButtonWidget(
            //                   title: CommonTexts.viewMoreButton,
            //                   onPressed: () {
            //                     //title에 br 제거
            //                     final String title =
            //                         node['title'].replaceAll('<br>', ' ');
            //                     final actionLinkInstance = ActionLink();
            //                     final actionLinkModel =
            //                         ActionLinkModel.fromJson(
            //                             node['actionLink']);
            //                     actionLinkInstance.handleActionLink(
            //                         context, actionLinkModel, title);
            //                   },
            //                 ),
            //               )
            //             else
            //               Container(),
            //           ],
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ));
  }
}
