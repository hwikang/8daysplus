import 'package:core/core.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';

import '../../../../../utils/strings.dart';
import '../../../../modules/discovery/search_all_module.dart';

class SearchAllBody extends StatefulWidget {
  const SearchAllBody({this.query, this.tabController});

  final String query;
  final TabController tabController;

  @override
  _SearchAllBodyState createState() => _SearchAllBodyState();
}

class _SearchAllBodyState extends State<SearchAllBody> {
  @override
  Widget build(BuildContext context) {
    final categoryBloc = Provider.of<CategoryBloc>(context);
    final categoryList = categoryBloc.repoList.value;

    return StreamBuilder<bool>(
        stream: Provider.of<SearchStateBloc>(context).allBodyEmpty,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return Container(
              height: MediaQuery.of(context).size.height - 150,
              child: const Center(
                  child: Text(DiscoveryPageStrings.search_noResult)),
            );
          }
          return Container(
            margin: const EdgeInsets.only(
              bottom: 48,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                // isEmptyList.add(false);
                return Provider<SearchListBloc>(
                  create: (context) => SearchListBloc(
                    first: 5,
                    keyword: widget.query,
                    type: categoryList[index].type,
                    categoryIds: categoryList[index].id,
                  ),
                  dispose: (context, bloc) {
                    // bloc.dispose();
                  },
                  child: SearchAllModule(
                      title: categoryList[index].name,
                      heroTagName: 'searchAll-experience',
                      widgetType: 'LIST',
                      index: index,
                      onPressButton: () {
                        widget.tabController.index = index + 1;
                      }),
                );
              },
            ),
          );
        });
  }
}
