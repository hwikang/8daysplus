import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/device_ratio.dart';
import '../../../utils/text_styles.dart';
import '../common/product-list/list_product_widget.dart';
import '../common/product-list/list_title_widget.dart';

class FeedListViewWidget extends StatelessWidget {
  const FeedListViewWidget({
    this.title,
    this.productList,
  });

  final List<ProductListViewModel> productList;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 48),
        child: Column(
          children: <Widget>[
            ListTitleWidget(title: title),
            ListViewWidget(
              productList: productList,
            ),
          ],
        ));
  }
}

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({
    this.productList,
  });

  final List<ProductListViewModel> productList;

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  int currentPage;
  int pageNum;
  int pageViewLenth;

  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);

    currentPage = 0;
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page.toInt();
      });
    });
  }

  Widget _buildDirectionView(List<ProductListViewModel> list, int pageIndex,
      PageController _controller) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Image.asset(
              ImageAssets.group_19_image,
              width: 40,
              height: 24,
            ),
            onPressed: () {
              _controller.animateToPage(
                pageIndex - 1,
                duration: const Duration(milliseconds: 300),
                curve: const Interval(
                  0.000,
                  0.650,
                  curve: Curves.ease,
                ),
              );
            },
          ),
          Text('${pageIndex + 1}/${(widget.productList.length / 3).ceil()}',
              style: TextStyles.black12TextStyle),
          FlatButton(
            child: Image.asset(
              ImageAssets.group_18_image,
              width: 40,
              height: 24,
            ),
            onPressed: () {
              _controller.animateToPage(
                pageIndex + 1,
                duration: const Duration(milliseconds: 300),
                curve: const Interval(
                  0.000,
                  0.650,
                  curve: Curves.ease,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<ProductListViewModel> list, int pageIndex) {
    List<ProductListViewModel> tList;
    final lengthDevidedByThree = list.length / 3;

    if (pageIndex + 1 == lengthDevidedByThree.ceil()) {
      //현재 마지막 페이지일때
      final currentList = list.sublist(pageIndex * 3, list.length);

      if (currentList.length < 3) {
        // 2개 이하면 마지막까지만 자름
        tList = list.sublist(pageIndex * 3, list.length);
      } else {
        tList = currentList;
      }
    } else {
      tList = list.sublist(pageIndex * 3, pageIndex * 3 + 3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListProductWidget(
        list: tList,
        scrollEnded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pageNum = (widget.productList.length / 3).ceil();
    pageViewLenth = widget.productList.length;
    if (pageViewLenth >= 3) {
      pageViewLenth = 3;
    }
    return Container(
        height: ((112.0 - DeviceRatio.listview(context)) * pageViewLenth) + 48,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            PageView.builder(
              key: PageStorageKey(UniqueKey()),
              controller: _controller,
              itemCount: pageNum,
              itemBuilder: (context, index) {
                return _buildListView(widget.productList, index);
              },
            ),
            _buildDirectionView(widget.productList, currentPage, _controller),
          ],
        ));
  }
}
