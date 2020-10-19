import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:html_widget/flutter_html.dart';
import 'package:html_widget/style.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_styles.dart';
import '../common/expansion_tile_widget.dart';
import '../common/loading_widget.dart';

class FaqPageBody extends StatefulWidget {
  const FaqPageBody({this.typeList});

  final List<FaqTypeModel> typeList;

  @override
  _FaqPageBodyState createState() => _FaqPageBodyState();
}

class _FaqPageBodyState extends State<FaqPageBody>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.typeList.length);
    _tabController.addListener(_handleTab);
  }

  void _handleTab() {
    if (_tabController.indexIsChanging) {
      final faqBloc = Provider.of<FaqBloc>(context);
      // faqBloc.clearControllers();
      faqBloc.search(widget.typeList[_tabController.index].type);
    }
  }

  Widget _buildMoreButton(BuildContext context) {
    final faqBloc = Provider.of<FaqBloc>(context);

    return GestureDetector(
      onTap: () {
        if (faqBloc.networkState.value != NetworkState.Finish) {
          faqBloc.getMore(widget.typeList[_tabController.index].type);
        }
      },
      child: Container(
        height: 48,
        child: Center(
          child: Text(
            '+더 보기',
            style: TextStyles.grey14TextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, FaqModel item, int index) {
    // final FaqBloc faqBloc = Provider.of<FaqBloc>(context);

    return Container(
        // decoration: BoxDecoration(
        //     border: Border(bottom: BorderSide(color: const Color(0xffeeeeee)))),
        child: ExpansionTileWidget(
      title: Container(
        padding: const EdgeInsets.only(left: 24, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 272,
                child: Text(
                  '${item.title}',
                  style: TextStyles.black14TextStyle,
                )),
          ],
        ),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: const Color(0xfff8f8f8),
          child: _buildText(context, item.message)),
    ));
  }

  Widget _buildText(BuildContext context, String text) {
    print(text);
    final data =
        text.replaceAll(RegExp("<font color='#373f52'>"), ''); //지원하지 않는 태그
    return Html(
      data: '''
        $data
      ''',
      // defaultTextStyle: TextStyles.black14TextStyle,
      style: <String, Style>{
        'body': Style(
          margin: const EdgeInsets.all(0),
          fontSize: FontSize(14.0 * MediaQuery.of(context).textScaleFactor),
          fontHeight: 2.0,
          color: const Color(0xff404040), fontFamily: FontFamily.regular,

          // fontWeight: FontWeight.bold
        ),
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final faqBloc = Provider.of<FaqBloc>(context);
    final tabs = faqBloc.typeList.value.map((type) {
      return Tab(text: type.name);
    }).toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 24),
      // color: Colors.red,
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xffeeeeee))),
      child: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: TextStyles.black14BoldTextStyle,
          unselectedLabelStyle: TextStyles.grey14TextStyle,
          unselectedLabelColor: const Color(0xffd0d0d0),
          indicatorPadding: const EdgeInsets.only(right: 20),
          labelPadding: const EdgeInsets.only(right: 20),
          tabs: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqBloc = Provider.of<FaqBloc>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTabBar(context),
          StreamBuilder<NetworkState>(
              stream: Provider.of<FaqBloc>(context).networkState,
              builder: (context, stateSnapshot) {
                print('faqBloc.faqList.value ${faqBloc.faqList.value}');
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: faqBloc.faqList.value.length + 1,
                    itemBuilder: (context, index) {
                      print('stateSnapshot.data ${stateSnapshot.data}');
                      if (index == faqBloc.faqList.value.length) {
                        if (stateSnapshot.data == NetworkState.Loading) {
                          return const Center(
                              heightFactor: 3.0, child: LoadingWidget());
                        }
                        if (stateSnapshot.data == NetworkState.Finish) {
                          return Container();
                        }

                        return _buildMoreButton(context);
                      } else {
                        return _buildList(
                            context, faqBloc.faqList.value[index], index);
                      }
                    });
              })
        ],
      ),
    );
  }
}
