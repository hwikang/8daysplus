import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'discovery/main/discovery_main_page.dart';

//router
class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<DiscoveryPageBloc>(
      create: (context) => DiscoveryPageBloc(),
      child: DiscoveryPageModule(),
    );
  }
}

class DiscoveryPageModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final discoveryPageBloc = Provider.of<DiscoveryPageBloc>(context);

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        Provider<DiscoveryMainPageBloc>(
            create: (context) =>
                DiscoveryMainPageBloc(model: discoveryPageBloc.mainModel),
            dispose: (context, bloc) {
              bloc.dispose();
            }),
        Provider<CategoryBloc>(create: (context) {
          return CategoryBloc();
        }, dispose: (context, bloc) {
          bloc.dispose();
        }),
        Provider<RecommendCategoryFeedBloc>(
            create: (context) => RecommendCategoryFeedBloc(
                // type: 'EXPERIENCE', categoryId: 'RVhQRVJJRU5DRSMzOTE='
                ),
            dispose: (context, bloc) {
              bloc.dispose();
            }),
      ],
      child: DiscoveryMainPage(
          initialIndex: discoveryPageBloc.mainModel.outerPageState //탭위치 보존
          ),
    );
  }
}
