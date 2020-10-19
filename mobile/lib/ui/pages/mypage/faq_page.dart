import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/routes.dart';
import '../../components/common/header_title_widget.dart';
import '../../components/common/loading_widget.dart';
import '../../components/my/faq_page_body.dart';
import '../../modules/common/handle_network_module.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FaqBloc>(
      create: (context) => FaqBloc(first: 10, type: 'NORMAL'),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              AppRoutes.pop(context);
            },
          ),
          title: const HeaderTitleWidget(title: 'FAQ'),
        ),
        body: FaqPageModule(),
      ),
    );
  }
}

class FaqPageModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HandleNetworkModule(
        networkState: Provider.of<FaqBloc>(context).networkState,
        retry: () {
          Provider.of<FaqBloc>(context)
              .search(Provider.of<FaqBloc>(context).type);
        },
        child: StreamBuilder<Map<String, dynamic>>(
            stream: Provider.of<FaqBloc>(context).repoList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingRingWidget();
              }

              print('snapshot.data ${snapshot.data['typeList']}');
              return FaqPageBody(
                typeList: snapshot.data['typeList'],
              );
            }));
  }
}
