import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';
import '../common/product-list/list_title_widget.dart';
import './feed_list_view_widget.dart';
import './google_map_widget.dart';

class FeedListMapWidget extends StatefulWidget {
  const FeedListMapWidget({this.node});

  final Map<String, dynamic> node;

  @override
  _FeedListMapWidgetState createState() => _FeedListMapWidgetState();
}

class _FeedListMapWidgetState extends State<FeedListMapWidget> {
  List<Map<String, dynamic>> productList;
  String selectedGroupName;
  int selectedTab;

  @override
  void initState() {
    super.initState();
    selectedTab = 0;
    productList = widget.node['feedListViewMapProducts'];
    if (productList.isNotEmpty) {
      selectedGroupName = productList[0]['name'];
    }
  }

  Widget _buildListMapTab() {
    final List<Map<String, dynamic>> productList =
        widget.node['feedListViewMapProducts'];

    return Container(
        height: 56,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffeeeeee)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  key: PageStorageKey(UniqueKey()),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        right: 4,
                      ),
                      child: CircularToggleButton(
                        margin: index == 0
                            ? const EdgeInsets.only(left: 24)
                            : const EdgeInsets.all(0),
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
            ),
          ],
        ));
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
          children: <Widget>[
            ListTitleWidget(title: widget.node['title']),
            const SizedBox(height: 14),
            GoogleMapMarkerWidget(
              productList: selectedGroup[0]['nodes'],
            ),
            _buildListMapTab(),
            const SizedBox(height: 20),
            ListViewWidget(
              productList: selectedGroup[0]['nodes'],
            ),
          ],
        ));
  }
}

class CircularToggleButton extends StatelessWidget {
  const CircularToggleButton({
    this.isClicked,
    this.onPressed,
    this.title,
    this.margin,
    this.index,
  });

  final int index;
  final bool isClicked;
  final EdgeInsets margin;
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      // width: 64,
      margin: margin,
      decoration: BoxDecoration(
          color: isClicked ? const Color(0xff313537) : const Color(0xffffffff),
          border: Border.all(
              color: const Color(0xffeeeeee), width: isClicked ? 0 : 1),
          borderRadius: BorderRadius.circular(16)),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: isClicked
              ? TextStyles.white14BoldTextStyle
              : TextStyle(
                  fontFamily: FontFamily.regular,
                  fontSize: 14,
                  color: const Color(0xffd0d0d0),
                ),
        ),
      ),
    );
  }
}
