import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../components/common/network_delay_widget.dart';
import '../../components/discovery/category_filter_modal.dart';

class CategoryFilterModule extends StatelessWidget {
  const CategoryFilterModule({
    this.filterType,
    this.searchFilterBloc,
    this.searchListBloc,
    this.categoryBloc,
  });

  final CategoryBloc categoryBloc;
  final String filterType; //type location
  final SearchFilterBloc searchFilterBloc;
  final SearchListBloc searchListBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryBloc.repoList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return NetworkDelayPage(
            retry: () {
              categoryBloc.fetch();
            },
          );
        }
        var selectedList = <CategoryModel>[];
        var categoryList = categoryBloc.repoList.value;
        print('categoryList $categoryList');
        switch (filterType) {
          case 'LOCATION':
            selectedList = categoryList.where((category) {
              return category.searchType == 'REGION_CATEGORY';
            }).toList();
            break;
          case 'TYPE':
            selectedList = categoryList.where((category) {
              return category.searchType == 'CATEGORY';
            }).toList();
            break;

          default:
        }
        var depth = 2;
        if (selectedList.isNotEmpty) {
          selectedList[0].childCount >= 2 ? depth = 3 : depth = 2;
        }
        print(selectedList.length);

        return CategoryFilterModal(
          filterType: filterType,
          searchFilterBloc: searchFilterBloc,
          searchListBloc: searchListBloc,
          depth: depth,
          categoryList: selectedList,
        );
      },
    );
  }
}
