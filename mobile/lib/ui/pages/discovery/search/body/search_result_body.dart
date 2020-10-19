import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/discovery/selected_filter_widget.dart';
import '../../../../modules/discovery/search_list_module.dart';

class SearchResultBody extends StatefulWidget {
  const SearchResultBody({this.type, this.rootScrollController});

  final ScrollController rootScrollController;
  final String type;

  @override
  _SearchResultBodyState createState() => _SearchResultBodyState();
}

class _SearchResultBodyState extends State<SearchResultBody> {
  ScrollController _bodyScrollController;

  @override
  void initState() {
    super.initState();
    _bodyScrollController = ScrollController();
    _bodyScrollController.addListener(() {
      final innerPosition = _bodyScrollController.position.pixels;
      if (innerPosition < 60) {
        //60까지는 루트 같이 움직임
        widget.rootScrollController.position.jumpTo(innerPosition);
      } else {
        // 60이후에는 루트 스크롤 고정
        widget.rootScrollController.position.jumpTo(60);
      }

      if (_bodyScrollController.position.pixels ==
          _bodyScrollController.position.maxScrollExtent) {
        Future<void>.delayed(Duration.zero, () {
          final searchListbloc = Provider.of<SearchListBloc>(context);
          if (searchListbloc.networkState.value != NetworkState.Finish) {
            searchListbloc.getMoreSearch();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchStateBloc = Provider.of<SearchStateBloc>(context);
    final categoryBloc = Provider.of<CategoryBloc>(context);
    final tabIndex = searchStateBloc.searchTabState.value;
    String typeKorName;
    if (tabIndex > 0) {
      typeKorName = categoryBloc.repoList.value[tabIndex - 1].name;
    }
    return Column(
      children: <Widget>[
        _buildSelectedFilter(context, tabIndex),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: SearchListModule(
                heroTagName: 'searchResult-$tabIndex',
                isCount: true,
                widgetType: 'LIST',
                typeKorName: typeKorName,
                scrollController: _bodyScrollController),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFilter(BuildContext context, int tabIndex) {
    final searchStateBloc = Provider.of<SearchStateBloc>(context);
    final Stream<List<SearchFilterModel>> filterModel =
        searchStateBloc.searchFilterModels; //현재 각 탭의 필터상태(정렬,금액)
    final searchListBloc = Provider.of<SearchListBloc>(context);

    return StreamBuilder<List<SearchFilterModel>>(
      stream: filterModel,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data[tabIndex].sort.name == '' &&
                snapshot.data[tabIndex].money.name == '')) {
          return Container(
            height: 0,
          );
        }
        final filterModel = snapshot.data[tabIndex];

        return SelectedFilterWidget(
          moneyName: filterModel.money.name,
          sortName: filterModel.sort.name,
          onTapSortFilter: () {
            filterModel.sort = const SortFilterModel();
            searchStateBloc.changeSearchFilterModel(tabIndex, filterModel);
            searchListBloc.search(
              orderBy: filterModel.sort.orderBy,
              after: '',
              priceRange: filterModel.money.priceRange,
            );
          },
          onTapMoneyFilter: () {
            filterModel.money = const MoneyFilterModel();

            searchStateBloc.changeSearchFilterModel(tabIndex, filterModel);
            searchListBloc.search(
              orderBy: filterModel.sort.orderBy,
              after: '',
              priceRange: filterModel.money.priceRange,
            );
          },
        );
      },
    );
  }
}
