import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../search_filter_widget.dart';

class SearchResultTab extends StatefulWidget {
  const SearchResultTab({this.tabController, this.categories});

  final List<CategoryModel> categories; //tab categories
  final TabController tabController;

  @override
  SearchResultTabState createState() => SearchResultTabState();
}

class SearchResultTabState extends State<SearchResultTab>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Widget page;
  String searchType;
  List<Widget> tabs = <Widget>[];

  @override
  void initState() {
    super.initState();
    tabs
      ..add(
        const Tab(text: DiscoveryPageStrings.search_all),
      )
      ..addAll(widget.categories.map((category) {
        return Tab(
          text: category.name,
        );
      }));
  }

  Widget _buildResultFilter(int tabIndex, String typeName) {
    final searchStateBloc = Provider.of<SearchStateBloc>(context);

    if (tabIndex == 0) {
      return Container();
    }
    return StreamBuilder<List<SearchFilterModel>>(
        stream: searchStateBloc.searchFilterModels,
        builder: (context, filterSnapshot) {
          if (!filterSnapshot.hasData) {
            return Container();
          }
          return SearchFilterWidget(
            typeName: typeName,
            searchFilterModel: filterSnapshot.data[tabIndex],
            showLocationTypeFilter: false,
            changeBasicFilterStateFunction:
                (moneyFilterModel, sortFilterModel) {
              final searchFilterModel = SearchFilterModel(
                  sort: sortFilterModel, money: moneyFilterModel);
              searchStateBloc.changeSearchFilterModel(
                  tabIndex, searchFilterModel);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: Provider.of<SearchStateBloc>(context).searchTabState,
        initialData: 0,
        builder: (context, tabSnapshot) {
          if (tabSnapshot.data > 0) {
            searchType = widget.categories[tabSnapshot.data - 1].type;
          } else {
            searchType = 'EXPERIENCE';
          }

          return SliverAppBar(
            expandedHeight: tabSnapshot.data == 0 ? 44 : 80,
            automaticallyImplyLeading: false,
            // backgroundColor: Colors.white,
            elevation: 1.0,
            titleSpacing: 0.0,
            pinned: true,
            title: PreferredSize(
                preferredSize: const Size.fromHeight(44),
                child: Container(
                  padding: const EdgeInsets.only(left: 24),
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                      indicatorColor: Colors.black,
                      controller: widget.tabController,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(right: 20),
                      indicatorPadding: const EdgeInsets.only(right: 20),
                      indicatorWeight: 2.0,
                      labelStyle: TextStyles.black14BoldTextStyle,
                      labelColor: Colors.black,
                      unselectedLabelStyle: TextStyles.grey14TextStyle,
                      unselectedLabelColor: Colors.grey,
                      tabs: tabs),
                )),
            bottom: PreferredSize(
                preferredSize:
                    Size.fromHeight(widget.tabController.index == 0 ? 0 : 36),
                child: _buildResultFilter(tabSnapshot.data, searchType)),
          );
        });
  }
}
