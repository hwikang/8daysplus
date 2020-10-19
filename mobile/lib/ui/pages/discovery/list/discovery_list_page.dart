import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/common/app-bar/basic_app_bar.dart';
import '../../../components/discovery/search_filter_widget.dart';
import '../../../components/discovery/selected_filter_widget.dart';
import '../../../modules/discovery/search_list_module.dart';

class DiscoveryListPage extends StatelessWidget {
  const DiscoveryListPage(
      {this.typeName, this.searchFilterModel, this.appTitle});

  final String appTitle;
  final SearchFilterModel searchFilterModel;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    var rootCategoryId = '';
    if (searchFilterModel.location.id != '') {
      rootCategoryId = searchFilterModel.location.id;
    } else if (searchFilterModel.type.id != '') {
      rootCategoryId = searchFilterModel.type.id;
    } else if (searchFilterModel.money.id != '') {}
    print('rootCategoryId $rootCategoryId');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BasicAppBar(
          title: appTitle,
        ),
        body: MultiProvider(
          providers: <SingleChildCloneableWidget>[
            Provider<SearchListBloc>(
              create: (context) {
                return SearchListBloc(
                  first: 10,
                  categoryRegionIds: searchFilterModel.location.id ?? '',
                  categoryIds: searchFilterModel.type.id == ''
                      ? searchFilterModel.money.id == ''
                          ? ''
                          : searchFilterModel.money.id
                      : searchFilterModel.type.id,
                  type: typeName,
                  orderBy: searchFilterModel.sort.orderBy,
                );
              },
              dispose: (context, bloc) {
                print('SearchListBloc dispose');
                bloc.dispose();
              },
            ),
            Provider<SearchFilterBloc>(
              create: (context) {
                return SearchFilterBloc(
                  model: searchFilterModel,
                );
              },
              dispose: (context, bloc) {
                print('SearchFilterBloc dispose');
                bloc.dispose();
              },
            ),
            Provider<CategoryBloc>(
              create: (context) {
                return CategoryBloc(
                  categoryId: rootCategoryId,
                );
              },
              dispose: (context, bloc) {
                // print('SearchFilterBloc dispose');
                bloc.dispose();
              },
            ),
          ],
          child: DiscoveryListBody(
              typeName: typeName,
              typeKorName: appTitle,
              showLocationTypeFilter: rootCategoryId != ''),
        ));
  }
}

class DiscoveryListBody extends StatefulWidget {
  const DiscoveryListBody(
      {this.typeName, this.typeKorName, this.showLocationTypeFilter = true});

  final bool showLocationTypeFilter;
  final String typeKorName;
  final String typeName;

  @override
  _DiscoveryListBodyState createState() => _DiscoveryListBodyState();
}

class _DiscoveryListBodyState extends State<DiscoveryListBody> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future<void>.delayed(Duration.zero, () {
      final searchListbloc = Provider.of<SearchListBloc>(context);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (searchListbloc.networkState.value != NetworkState.Finish) {
            searchListbloc.getMoreSearch();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchFilterBloc = Provider.of<SearchFilterBloc>(context);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          StreamBuilder<SearchFilterModel>(
              stream: Provider.of<SearchFilterBloc>(context).filterList,
              builder: (context, filterModelSnapShot) {
                final searchFilterModel = filterModelSnapShot.data;

                return SearchFilterWidget(
                  typeName: widget.typeName,
                  searchFilterModel: searchFilterModel,
                  showLocationTypeFilter: widget.showLocationTypeFilter,
                  changeBasicFilterStateFunction:
                      (moneyFilterModel, sortFilterModel) {
                    searchFilterBloc.changeSortFilter(sortFilterModel);
                    searchFilterBloc.changeMoneyFilter(moneyFilterModel);
                  },
                  //처음 선택한 카테고리
                );
              }),
          _buildSelectedWidget(context),
          SearchListModule(
            heroTagName: 'discoveryListResult',
            isCount: true,
            widgetType: 'GRID',
            typeKorName: widget.typeKorName,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedWidget(BuildContext context) {
    final searchFilterBloc = Provider.of<SearchFilterBloc>(context);
    final searchListBloc = Provider.of<SearchListBloc>(context);

    return StreamBuilder<SearchFilterModel>(
      stream: searchFilterBloc.filterList,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data.sort.name == '' && snapshot.data.money.name == '')) {
          return Container(
            height: 0,
          );
        }

        return SelectedFilterWidget(
          moneyName: snapshot.data.money.name,
          sortName: snapshot.data.sort.name,
          onTapSortFilter: () {
            searchFilterBloc.changeSortFilter(const SortFilterModel());
            searchListBloc.search(orderBy: const OrderByModel());
          },
          onTapMoneyFilter: () {
            searchFilterBloc.changeMoneyFilter(const MoneyFilterModel());
            searchListBloc.search(
                priceRange: searchFilterBloc.model.money.priceRange);
          },
        );
      },
    );
  }
}
