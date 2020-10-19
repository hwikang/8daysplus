import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/action_link.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/strings.dart';
import '../../pages/my_page.dart';
import '../common/button/white_button_widget.dart';
import '../common/product-list/grid_product_widget.dart';
import '../common/product-list/list_title_widget.dart';
import 'feed_list_map_widget.dart';

class FeedGridGroupProductWidget extends StatefulWidget {
  const FeedGridGroupProductWidget({this.node});

  final Map<String, dynamic> node;

  @override
  _FeedGridGroupProductWidgetState createState() =>
      _FeedGridGroupProductWidgetState();
}

class _FeedGridGroupProductWidgetState
    extends State<FeedGridGroupProductWidget> {
  String selectedGroupName;
  int selectedTab;

  List<Map<String, dynamic>> productList;
  @override
  void initState() {
    super.initState();
    selectedTab = 0;

    productList = widget.node['feedGridGroupProducts'];
    if (productList.isNotEmpty) {
      selectedGroupName = productList[0]['name'];
    }
  }

  Widget _buildTab(
      BuildContext context, List<Map<String, dynamic>> productList) {
    return Container(
      child: ListView.builder(
          key: PageStorageKey(UniqueKey()),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 4),
              child: CircularToggleButton(
                index: index,
                margin: EdgeInsets.only(left: index == 0 ? 24 : 0),
                isClicked: selectedTab == index,
                title: productList[index]['name'],
                onPressed: () {
                  setState(() {
                    selectedTab = index;
                    selectedGroupName = productList[index]['name'];
                  });
                },
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      return Container();
    }
    final selectedGroup = productList.where((group) {
      return selectedGroupName == group['name'];
    }).toList();
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTitleWidget(title: widget.node['title']),
              Container(
                margin: const EdgeInsets.only(
                  top: 14,
                  bottom: 16,
                ),
                height: 32,
                child: _buildTab(context, widget.node['feedGridGroupProducts']),
              ),
              GridProductWidget(
                list: selectedGroup[0]['nodes'],
                isCount: false,
                labelType: widget.node['labelType'],
                scrollEnded: true,
              ),
              if (widget.node['bannerView'])
                Container(
                    margin: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                    ),
                    child: StyleAnalyzeBanner())
              else
                Container(),
              if (widget.node['overView'])
                Container(
                  margin: const EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                  ),
                  width: 312 * DeviceRatio.scaleWidth(context),
                  child: WhiteButtonWidget(
                    title: CommonTexts.viewMoreButton,
                    onPressed: () {
                      final actionLinkInstance = ActionLink();
                      final actionLinkModel =
                          ActionLinkModel.fromJson(widget.node['actionLink']);
                      actionLinkInstance.handleActionLink(
                          context, actionLinkModel, widget.node['title']);
                    },
                  ),
                )
              else
                Container(),
            ]));
  }
}
