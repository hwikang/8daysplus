import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../utils/device_ratio.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/loading_widget.dart';

class MyPageStyleSelectPage extends StatelessWidget {
  const MyPageStyleSelectPage({this.isSkippable = true});

  final bool isSkippable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '스타일 선택',
            style: TextStyles.black18BoldTextStyle,
          ),
        ),
      ),
      body: Provider<MyStyleSelectPageBloc>(
        create: (context) => MyStyleSelectPageBloc(),
        dispose: (context, bloc) {
          bloc.dispose();
        },
        child: StyleSelectWidget(
          isSkippable: isSkippable,
        ),
      ),
      // body: StyleAnalysisWidget(),
    );
  }
}

class StyleSelectWidget extends StatelessWidget {
  const StyleSelectWidget({this.isSkippable});

  final bool isSkippable;

  Widget _builSkipButton(BuildContext context) {
    if (isSkippable) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        AppRoutes.firstMainPage(context);
      },
      child: Container(
          color: Colors.transparent,
          child: Text('건너뛰기>', style: TextStyles.grey14TextStyle)),
    );
  }

  Widget _buildPickCounter(
    BuildContext context,
  ) {
    return StreamBuilder<int>(
        stream: Provider.of<MyStyleSelectPageBloc>(context).pickCountController,
        initialData: 0,
        builder: (context, countSnapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              alignment: Alignment.center,
              width: 44,
              height: 20,
              color: const Color(0xff404040),
              child: Text('${countSnapshot.data}Pick',
                  style: TextStyles.white10TextStyle),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // print('ddddddd ${mainPageBloc.repoList.value.length}');
    return StreamBuilder<Map<String, dynamic>>(
      stream: Provider.of<MyStyleSelectPageBloc>(context).repoJson,
      builder: (context, repoSnapshot) {
        if (!repoSnapshot.hasData) {
          return const LoadingWidget();
        }

        return Container(
          margin: const EdgeInsets.only(
            top: 24,
            // left: 30, right: 30
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildPickCounter(context),
              const SizedBox(
                height: 13,
              ),
              StreamBuilder<bool>(
                  stream: Provider.of<MyStyleSelectPageBloc>(context).isLast,
                  initialData: false,
                  builder: (context, snapshot) {
                    return Container(
                      width: 300 * DeviceRatio.scaleWidth(context),
                      child: Text(
                        snapshot.data
                            ? '더이상 평가할 상품이 없습니다.\n새로운 상품을 준비중에 있습니다.'
                            : repoSnapshot.data['title'],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyles.black20BoldTextStyle,
                      ),
                    );
                  }),
              const SizedBox(
                height: 24,
              ),
              StreamBuilder<List<ProductListViewModel>>(
                  stream: Provider.of<MyStyleSelectPageBloc>(context)
                      .productListController,
                  initialData: const <ProductListViewModel>[],
                  builder: (context, productSnapshot) {
                    return StyleSelectPageViewWidget(
                        productList: productSnapshot.data);
                  }),
              Container(child: _builSkipButton(context)),
            ],
          ),
        );
      },
    );
  }
}

class StyleSelectPageViewWidget extends StatefulWidget {
  const StyleSelectPageViewWidget({this.productList});

  final List<ProductListViewModel> productList;

  @override
  _StyleSelectPageViewWidgetState createState() =>
      _StyleSelectPageViewWidgetState();
}

class _StyleSelectPageViewWidgetState extends State<StyleSelectPageViewWidget> {
  double currentPageValue;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      final myStyleSelectPageBloc = Provider.of<MyStyleSelectPageBloc>(context);
      if (pageController.page >= widget.productList.length - 0.5) {
        myStyleSelectPageBloc.onLastPage();
      } else // 다시 앞으로
      {
        myStyleSelectPageBloc.onOtherPage();
      }
      setState(() {
        currentPageValue = pageController.page;
      });
    });
  }

  Widget _buildEmptyStyleSelectView(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 300 * DeviceRatio.scaleWidth(context),
            width: 300 * DeviceRatio.scaleWidth(context),
            color: const Color(0xfffafafa),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffeeeeee),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffeeeeee),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffeeeeee),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color(0x19000000),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0)
              ],
            ),
            child: Container(
              color: Colors.transparent,
              child: Icon(
                Icons.favorite,
                color: const Color(0xfffafafa),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context, int index) {
    return Container(
      height: 300 * DeviceRatio.scaleWidth(context),
      width: 300 * DeviceRatio.scaleWidth(context),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0x7f000000), Color(0x00000000)],
                      stops: <double>[0, 1]),
                ),
                // margin: EdgeInsets.symmetric(vertical: 15),
                child: Image.network(
                  widget.productList[index].image.url,
                  // width: 300 * DeviceRatio.scaleWidth(context),
                  height: 300 * DeviceRatio.scaleWidth(context),
                  fit: BoxFit.fitHeight,
                )),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                // color: Colors.yellow,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                width: 260 * DeviceRatio.scaleWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '픽 0%',
                      style: TextStyles.white12BoldTextStyle,
                    ),
                    Text(
                      widget.productList[index].name,
                      style: TextStyles.white16BoldTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 20,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productList[index].tags.length,
                        itemBuilder: (context, tagIndex) {
                          return _buildTagWidget(context,
                              widget.productList[index].tags[tagIndex]);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTagWidget(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffffffff), width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        maxLines: 1,
        style: TextStyles.white12TextStyle,
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        children: <Widget>[
          Container(
            height: 300 * DeviceRatio.scaleWidth(context) + 112,
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.productList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.productList.length) {
                  return _buildEmptyStyleSelectView(context);
                }
                return Column(
                  children: <Widget>[
                    _buildImageWidget(context, index),
                    const SizedBox(
                      height: 24,
                    ),
                    StyleSelectHeartWidget(
                      pageController: pageController,
                      productId: widget.productList[index].id,
                      typeName: widget.productList[index].typeName,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StyleSelectHeartWidget extends StatefulWidget {
  const StyleSelectHeartWidget(
      {this.pageController, this.productId, this.typeName});

  final PageController pageController;
  final String productId;
  final String typeName;

  @override
  _StyleSelectHeartWidgetState createState() => _StyleSelectHeartWidgetState();
}

class _StyleSelectHeartWidgetState extends State<StyleSelectHeartWidget> {
  bool isClicked;

  @override
  void initState() {
    super.initState();
    isClicked = false;
  }

  Widget _buildHeartIcon(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Icon(
          Icons.favorite,
          color: isClicked ? const Color(0xffff7500) : const Color(0xfffafafa),
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = true;
        });
        final myStyleSelectPageBloc =
            Provider.of<MyStyleSelectPageBloc>(context);
        myStyleSelectPageBloc
            .addRecommendPick(widget.productId, widget.typeName)
            .then((res) {
          if (res) {
            // myStyleSelectPageBloc.removeItemFromList(widget.productId);
            widget.pageController
                .animateToPage(widget.pageController.page.round() + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn)
                .whenComplete(() {
              widget.pageController.jumpToPage(
                  widget.pageController.page.round() -
                      1); //상품이 삭제되면 0 부터이므로 다시 전 페이지로 돌아와야함

              myStyleSelectPageBloc.removeItemFromList(
                  widget.productId, widget.pageController.page);
              setState(() {
                isClicked = false;
              });
            });
          }
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
        ),
        child: _buildHeartIcon(context),
      ),
    );
  }
}
