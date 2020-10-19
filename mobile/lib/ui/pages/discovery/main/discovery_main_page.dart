import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../utils/firebase_analytics.dart';
import '../../../../utils/singleton.dart';
import '../../../components/common/network_delay_widget.dart';
import 'widget/discovery_main_content.dart';
import 'widget/discovery_main_header.dart';
import 'widget/discovery_main_tab.dart';
import 'widget/discovery_root_tab.dart';

class DiscoveryMainPage extends StatefulWidget {
  const DiscoveryMainPage({this.initialIndex});

  final int initialIndex;

  @override
  DiscoveryMainPageState createState() => DiscoveryMainPageState();
}

class DiscoveryMainPageState extends State<DiscoveryMainPage>
    with AutomaticKeepAliveClientMixin<DiscoveryMainPage> {
  @override
  bool get wantKeepAlive => true;

  void fetch() {
    final recommendCategoryBloc =
        Provider.of<RecommendCategoryFeedBloc>(context);
    final categoryBloc = Provider.of<CategoryBloc>(context);

    recommendCategoryBloc.fetch();
    categoryBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<DiscoveryMainPageModel>(
        stream: Provider.of<DiscoveryMainPageBloc>(context).mainModelState,
        initialData: DiscoveryMainPageModel(),
        builder: (context, mainModelStateSnapshot) {
          return StreamBuilder<List<CategoryModel>>(
              stream: Provider.of<CategoryBloc>(context).repoList,
              builder: (context, stateSnapshot) {
                if (stateSnapshot.hasError) {
                  return NetworkDelayPage(
                    retry: () {
                      fetch();
                    },
                  );
                }

                if (!stateSnapshot.hasData) {
                  return Container();
                }

                return DiscoveryMainBody(
                    initialOuterTabIndex: widget.initialIndex,
                    tabLength: stateSnapshot.data.length);
              });
        });
  }
}

class DiscoveryMainBody extends StatefulWidget {
  const DiscoveryMainBody({this.initialOuterTabIndex, this.tabLength});

  final int initialOuterTabIndex;
  final int tabLength;

  @override
  _DiscoveryMainBodyState createState() => _DiscoveryMainBodyState();
}

class _DiscoveryMainBodyState extends State<DiscoveryMainBody>
    with TickerProviderStateMixin {
  int innerTabIndex = 0;
  int outerTabIndex;
  Widget page;
  CategoryState selectedCategoryState = CategoryState.Content;

  TabController _outerTabController;
  ScrollController _scrollController;

  @override
  void dispose() {
    super.dispose();
    _outerTabController?.dispose();
    _outerTabController = null;
  }

  @override
  void initState() {
    super.initState();

    outerTabIndex = widget.initialOuterTabIndex;

    _outerTabController = TabController(
        vsync: this,
        length: widget.tabLength,
        initialIndex: widget.initialOuterTabIndex ?? 0);
    _outerTabController.addListener(_handleOuterTab);

    //didChangeDependencies called several time so use Schedular
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final recommendCategoryBloc =
          Provider.of<RecommendCategoryFeedBloc>(context);
      final categoryBloc = Provider.of<CategoryBloc>(context);
      final rootCategory =
          categoryBloc.repoList.value[_outerTabController.index];

      recommendCategoryBloc.changeRecommendCategory(
        rootCategory.type,
        rootCategory.nodes[innerTabIndex].id,
      );
      final navBloc = Provider.of<NavbarBloc>(context);
      _scrollController = navBloc.discoveryPageScrollController;
    });
  }

  void _handleInnerTab(int index) {
    setState(() {
      innerTabIndex = index;
    });
    final discoveryMainPageBloc = Provider.of<DiscoveryMainPageBloc>(context);

    final recommendCategoryBloc =
        Provider.of<RecommendCategoryFeedBloc>(context);
    final categoryBloc = Provider.of<CategoryBloc>(context);

    final rootCategory = categoryBloc.repoList.value[_outerTabController.index];

    discoveryMainPageBloc.changeInnerPageState(index, rootCategory.id);

    recommendCategoryBloc.changeRecommendCategory(
      rootCategory.type,
      rootCategory.nodes[innerTabIndex].id,
    );
    getLogger(this).d('change inner tab $index ${rootCategory.name}');
  }

  void _handleOuterTab() {
    //이거안하면 두번 실행됨
    if (!_outerTabController.indexIsChanging) {
      setState(() {
        outerTabIndex = _outerTabController.index;

        innerTabIndex = 0;
      });

      final recommendCategoryFeedBloc =
          Provider.of<RecommendCategoryFeedBloc>(context);
      final discoveryMainPageBloc = Provider.of<DiscoveryMainPageBloc>(context);
      final categoryBloc = Provider.of<CategoryBloc>(context);

      //선택한 1depth
      final rootCategory =
          categoryBloc.repoList.value[_outerTabController.index];
      // print('selected outerTab category id ${rootCategory.id}');
      discoveryMainPageBloc.changeOuterPageState(
          _outerTabController.index, rootCategory.id);
      discoveryMainPageBloc.changeInnerPageState(
          innerTabIndex, rootCategory.nodes[0].id);

      //카테고리 best 상태 변경
      recommendCategoryFeedBloc.changeRecommendCategory(
        rootCategory.type,
        rootCategory.nodes[innerTabIndex].id,
      );

      getLogger(this).d('change outer tab $outerTabIndex ${rootCategory.name}');
    }
  }

  void analyticsSetScreen() {
    final discoveryMainPageBloc = Provider.of<DiscoveryMainPageBloc>(context);
    final categoryBloc = Provider.of<CategoryBloc>(context);
    final cateModel =
        categoryBloc.repoList.value[discoveryMainPageBloc.model.outerPageState];

    if (cateModel.nodes.isNotEmpty) {
      final _analyticsParameter = <String, dynamic>{
        'view_category': cateModel.name,
        'view_list':
            cateModel.nodes[discoveryMainPageBloc.model.innerPageState].name,
        'location': '${Singleton.instance.curLat},${Singleton.instance.curLng}',
      };
      Analytics.analyticsLogEvent('view_item_list', _analyticsParameter);

      if (cateModel.name.contains('클래스')) {
        if (cateModel.nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('지역')) {
          Analytics.analyticsScreenName('Disco_Class_Location');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('분야')) {
          Analytics.analyticsScreenName('Disco_Class_Category');
        }
      } else if (cateModel.name.contains('액티비티')) {
        if (cateModel.nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('여행지')) {
          Analytics.analyticsScreenName('Disco_Activiity_Location');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('예산')) {
          Analytics.analyticsScreenName('Disco_Activiity_Price');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('액티비티')) {
          Analytics.analyticsScreenName('Disco_Activiity_Category');
        }
      } else if (cateModel.name.contains('매거진')) {
        if (cateModel.nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('자기계발')) {
          Analytics.analyticsScreenName('Disco_Magazine_SelfImprovement');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('컬쳐')) {
          Analytics.analyticsScreenName('Disco_Magazine_Culture');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('금융자산')) {
          Analytics.analyticsScreenName('Disco_Magazine_Finance');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('여행')) {
          Analytics.analyticsScreenName('Disco_Magazine_Travel');
        }
      } else if (cateModel.name.contains('쿠폰')) {
        if (cateModel.nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('브랜드')) {
          Analytics.analyticsScreenName('Disco_eCoupon_Brand');
        } else if (cateModel
            .nodes[discoveryMainPageBloc.model.innerPageState].name
            .contains('테마')) {
          Analytics.analyticsScreenName('Disco_eCoupon_Thema');
        }
      } else {
        Analytics.analyticsScreenName('Disco_No_Define');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: DiscoveryMainHeader(),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          final categoryBloc = Provider.of<CategoryBloc>(context);
          final rootCategory =
              categoryBloc.repoList.value[_outerTabController.index];

          categoryBloc.refresh();
          final recommendCategoryBloc =
              Provider.of<RecommendCategoryFeedBloc>(context);

          return recommendCategoryBloc.changeRecommendCategory(
              rootCategory.type, rootCategory.nodes[innerTabIndex].id);

          // return recommendCategoryBloc.refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          // physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              elevation: 1.0,
              titleSpacing: 0.0,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              title: DiscoveryRootTab(
                tabController: _outerTabController,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                DiscoveryMainTab(
                  handleInnerTab: _handleInnerTab,
                  innerTabIndex: innerTabIndex,
                ),
                DiscoveryMainContent(innerTabIndex: innerTabIndex),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
