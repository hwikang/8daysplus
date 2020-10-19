import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/handle_network_error.dart';
import '../../components/common/product-list/grid_product_widget.dart';
import '../../components/common/product-list/list_product_widget.dart';

class SearchListModule extends StatelessWidget {
  const SearchListModule({
    this.heroTagName,
    @required this.isCount,
    @required this.widgetType,
    this.forceScrollEnd,
    this.typeKorName,
    this.scrollController,
  });

  final bool forceScrollEnd; //temp for 통합
  final String heroTagName;
  final bool isCount;
  final ScrollController scrollController;
  final String typeKorName;
  final String widgetType;

  @override
  Widget build(BuildContext context) {
    print('build search list');
    return StreamBuilder<NetworkState>(
        stream: Provider.of<SearchListBloc>(context).networkState,
        builder: (context, networkSnapshot) {
          var scrollEnded = networkSnapshot.data == NetworkState.Finish;
          if (forceScrollEnd != null && forceScrollEnd) {
            scrollEnded = true;
          }
          final searchListBloc = Provider.of<SearchListBloc>(context);

          return HandleNetworkError.handleNetwork(
              state: networkSnapshot.data,
              retry: searchListBloc.search,
              child: StreamBuilder<List<ProductListViewModel>>(
                  stream: Provider.of<SearchListBloc>(context).searchList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (snapshot.data.isEmpty) {
                      return Container(
                          height: 524,
                          child: const Center(child: Text('검색 결과가 없습니다.')));
                    }
                    final searchListBloc = Provider.of<SearchListBloc>(context);
                    final totalCount = searchListBloc.getTotalCount();
                    Widget widget;

                    switch (widgetType) {
                      case 'GRID':
                        widget = GridProductWidget(
                            list: snapshot.data,
                            isCount: isCount,
                            totalCount: totalCount,
                            scrollEnded: scrollEnded,
                            typeKorName: typeKorName);
                        break;
                      case 'LIST':
                        widget = ListProductWidget(
                          list: snapshot.data,
                          // heroTagName: heroTagName,
                          isCount: isCount,
                          totalCount: totalCount,
                          scrollEnded: scrollEnded,
                          typeKorName: typeKorName,
                          highlightText: searchListBloc.getKeyword(),
                          scrollController: scrollController,
                          physics: const BouncingScrollPhysics(),
                        );
                    }
                    return widget;
                  }));
        });

    // StreamBuilder<List<ProductListViewModel>>(
    //     stream: Provider.of<SearchListBloc>(context).searchList,
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return Container();
    //       }
    //       if (snapshot.data.isEmpty) {
    //         return Container(
    //             height: 524, child: const Center(child: Text('검색 결과가 없습니다.')));
    //       }
    //       final searchListBloc = Provider.of<SearchListBloc>(context);
    //       final totalCount = searchListBloc.getTotalCount();
    //       Widget widget;
    //       return StreamBuilder<NetworkState>(
    //           stream: Provider.of<SearchListBloc>(context).networkState,
    //           builder: (context, networkSnapshot) {
    //             var scrollEnded = networkSnapshot.data == NetworkState.Finish;
    //             if (forceScrollEnd != null && forceScrollEnd) {
    //               scrollEnded = true;
    //             }
    //             logger.w(networkSnapshot.data);

    //             switch (widgetType) {
    //               case 'GRID':
    //                 widget = GridProductWidget(
    //                     list: snapshot.data,
    //                     isCount: isCount,
    //                     totalCount: totalCount,
    //                     scrollEnded: scrollEnded,
    //                     typeKorName: typeKorName);
    //                 break;
    //               case 'LIST':
    //                 widget = ListProductWidget(
    //                   list: snapshot.data,
    //                   // heroTagName: heroTagName,
    //                   isCount: isCount,
    //                   totalCount: totalCount,
    //                   scrollEnded: scrollEnded,
    //                   typeKorName: typeKorName,
    //                   highlightText: searchListBloc.getKeyword(),
    //                   scrollController: scrollController,
    //                   physics: const BouncingScrollPhysics(),
    //                 );
    //             }
    //             return
    //                 // widget;

    //                 HandleNetworkError.handleNetwork(
    //                     state: networkSnapshot.data,
    //                     child: widget,
    //                     retry: searchListBloc.search);
    //           });
    // });
  }
}
