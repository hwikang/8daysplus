import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/singleton.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/discovery/search/search_result_tab.dart';
import 'body/search_all_body.dart';
import 'body/search_result_body.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({this.categories});

  final List<CategoryModel> categories; //tab categories

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  ScrollController _rootScrollController;
  TabController _tabController;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    Future<void>.delayed(Duration.zero, () {
      final searchListbloc = Provider.of<SearchListBloc>(context);

      _textController.text = searchListbloc.getKeyword();
    });
    _tabController =
        TabController(vsync: this, length: widget.categories.length + 1);
    _tabController.addListener(_handleSelection);
    _rootScrollController = ScrollController(initialScrollOffset: 0);
  }

  void _handleSelection() {
    if (!_tabController.indexIsChanging) {
      final searchStateBloc = Provider.of<SearchStateBloc>(context);
      searchStateBloc.changeTabState(_tabController.index);
      String searchType;
      SearchFilterModel searchFilterModel;
      if (_tabController.index != 0) {
        searchType =
            widget.categories[searchStateBloc.searchTabState.value - 1].type;
        searchFilterModel =
            searchStateBloc.searchFilterModels.value[_tabController.index];

        final searchListBloc = Provider.of<SearchListBloc>(context);
        searchListBloc.search(
          type: searchType,
          after: '',
          categoryIds:
              widget.categories[searchStateBloc.searchTabState.value - 1].id,
          orderBy: searchFilterModel.sort.orderBy,
          priceRange: searchFilterModel.money.priceRange,
        );
      }
    }
  }

  Widget _buildInputHeader(BuildContext context) {
    final searchStatebloc = Provider.of<SearchStateBloc>(context);
    return Container(
      height: 44,
      child: TextField(
        onTap: () {
          if (searchStatebloc.searchBodyState.value == SearchBodyState.Result) {
            searchStatebloc.changeTabState(0);
            searchStatebloc.changeBodyState(SearchBodyState.Suggestion);
          }
        },
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyles.black14TextStyle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              ImageAssets.searchIconImage,
              color: const Color(0xffe0e0e0),
              width: 18,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe0e0e0), width: 1.0),
          ),
          suffixIcon: IconButton(
            icon: Container(
              width: 20,
              child: Image(image: AssetImage(ImageAssets.searchClearIcon)),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Analytics.analyticsScreenName('Search');
    final _analyticsParameter = <String, dynamic>{
      'search_keyword': _textController.text,
      'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
    };
    Analytics.analyticsLogEvent('search', _analyticsParameter);

    // final searchListBloc = Provider.of<SearchListBloc>(context);

    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _rootScrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: Container(
                    height: 44,
                    margin: const EdgeInsets.only(top: 8, left: 24),
                    child: _buildInputHeader(context),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 58,
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            CommonTexts.cancel,
                            style: TextStyles.black14TextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width:16,)
                  ],
                ),
                SearchResultTab(
                  tabController: _tabController,
                  categories: widget.categories,
                ),
              ];
            },
            body: StreamBuilder<int>(
              stream: Provider.of<SearchStateBloc>(context).searchTabState,
              builder: (context, tabSnapshot) {
                final searchListBloc = Provider.of<SearchListBloc>(context);
                print('tab state = ${tabSnapshot.data}');
                if (tabSnapshot.data == 0) {
                  return SingleChildScrollView(
                    key: const PageStorageKey<String>('searchTab-all'),
                    child: SearchAllBody(
                      query: searchListBloc.getKeyword(),
                      tabController: _tabController,
                    ),
                  );
                }
                return SearchResultBody(
                  rootScrollController: _rootScrollController,
                );
              },
            ),
          ),
        )));
  }
}
