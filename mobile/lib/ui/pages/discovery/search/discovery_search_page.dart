import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/common/loading_widget.dart';
import '../../../components/common/network_delay_widget.dart';
import 'search_result_page.dart';
import 'search_suggestion_page.dart';

class DiscoverySearchPage extends StatelessWidget {
  const DiscoverySearchPage({
    this.searchBodyState = SearchBodyState.Suggestion,
    this.keyword = '',
  });

  final String keyword;
  final SearchBodyState searchBodyState;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        Provider<SearchStateBloc>(
          //suggestion & result
          create: (context) =>
              SearchStateBloc(initSearchBodyState: searchBodyState),
          dispose: (context, bloc) {
            print('state bloc close');
            bloc.dispose();
          },
        ),
        Provider<SearchKeywordBloc>(
          create: (context) => SearchKeywordBloc(keyword: keyword),
          dispose: (context, bloc) {
            bloc.dispose();
          },
        ),
        Provider<SearchListBloc>(
          create: (context) =>
              SearchListBloc(type: 'EXPERIENCE', keyword: keyword),
          dispose: (context, bloc) {
            bloc.dispose();
          },
        ),
        Provider<CategoryBloc>(
          create: (context) => CategoryBloc(),
          dispose: (context, bloc) {
            bloc.dispose();
          },
        ),
      ],
      child: DiscoverySearchPageModule(),
    );
  }
}

class DiscoverySearchPageModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchBodyState>(
      stream: Provider.of<SearchStateBloc>(context).searchBodyState,
      builder: (context, snapshot) {
        if (snapshot.data == SearchBodyState.Suggestion) {
          return SearchSuggestionPage();
        }

        return StreamBuilder<List<CategoryModel>>(
            stream: Provider.of<CategoryBloc>(context).repoList,
            builder: (context, categorySnapshot) {
              if (categorySnapshot.hasError) {
                return NetworkDelayPage(
                  retry: () {
                    Provider.of<CategoryBloc>(context).fetch();
                  },
                );
              }
              if (!categorySnapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: const LoadingWidget(),
                );
              }

              final categories = categorySnapshot.data;
              return SearchResultPage(categories: categories);
            });
      },
    );
  }
}
