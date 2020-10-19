import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/strings.dart';
import '../../components/common/button/white_button_widget.dart';
import '../../components/common/product-list/grid_product_widget.dart';
import '../../components/common/product-list/list_product_widget.dart';
import '../../components/common/product-list/list_title_widget.dart';

//통합 검색용
class SearchAllModule extends StatelessWidget {
  const SearchAllModule(
      {
      // this.changeIsAllEmptyState,
      this.heroTagName,
      @required this.widgetType,
      this.title,
      this.onPressButton,
      this.index});

  final String heroTagName;
  final int index;
  final Function onPressButton;
  final String title;
  final String widgetType;

  // Function changeIsAllEmptyState;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductListViewModel>>(
        stream: Provider.of<SearchListBloc>(context).searchList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center();
          }

          print('snapshot ${snapshot.data}');

          final searchStateBloc = Provider.of<SearchStateBloc>(context);
          searchStateBloc
              .addIsEmptyState(snapshot.data.isEmpty); //save empty state
          print(searchStateBloc.isEmptyList);
          if (snapshot.data.isEmpty) {
            if (searchStateBloc.isEmptyList.length == 4) {
              //last added type

              final isAllEmpty =
                  !searchStateBloc.isEmptyList.contains(false); //is all empty?
              searchStateBloc.changeAllBodyEmptyState(
                  isAllEmpty); //change state if all empty
            }
            return Container();
          }
          Widget widget;

          switch (widgetType) {
            case 'GRID':
              widget = GridProductWidget(
                list: snapshot.data,
                isCount: false,
                scrollEnded: true,
              );
              break;
            case 'LIST':
              widget = ListProductWidget(
                  list: snapshot.data,
                  // heroTagName: heroTagName,
                  isCount: false,
                  scrollEnded: true);
          }
          return Container(
            margin: const EdgeInsets.only(
              top: 24,
            ),
            child: Column(
              children: <Widget>[
                ListTitleWidget(
                  title: title,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: widget),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: 312 * DeviceRatio.scaleWidth(context),
                  child: WhiteButtonWidget(
                      title: CommonTexts.viewMoreButton,
                      onPressed: onPressButton),
                )
              ],
            ),
          );
        });
  }
}
