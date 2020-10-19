import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/text_styles.dart';

class DiscoveryMainTab extends StatelessWidget {
  const DiscoveryMainTab({
    this.handleInnerTab,
    this.innerTabIndex,
  });

  final Function handleInnerTab;
  final int innerTabIndex;

  Widget _buildChildTab(
      BuildContext context, CategoryModel model, int index, bool isChoosed) {
    final texts = model.summary.split('<br>');
    return GestureDetector(
      onTap: () {
        handleInnerTab(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChoosed ? const Color(0xff404040) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 106 * MediaQuery.of(context).textScaleFactor + 32,
        margin: EdgeInsets.only(right: 12, left: index == 0 ? 24 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                imageUrl: model.coverImage.url,
                width: 32,
                height: 32,
                color: isChoosed ? Colors.white : const Color(0xff404040),
              ),
            ),
            Container(child: _splitText(texts, isChoosed)),
          ],
        )),
      ),
    );
  }

  Widget _splitText(List<String> texts, bool isChoosed) {
    // List<String> text = longText.split('<br>');
    if (texts.length == 1) {
      return Text(texts[0],
          style: isChoosed
              ? TextStyles.white14BoldTextStyle
              : TextStyles.black14TextStyle);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(texts[0],
            style: isChoosed
                ? TextStyles.white14BoldTextStyle
                : TextStyles.black14TextStyle),
        Text(texts[1] ?? '',
            style: isChoosed
                ? TextStyles.white14BoldTextStyle
                : TextStyles.black14TextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryBloc = Provider.of<CategoryBloc>(context);

    return StreamBuilder<DiscoveryMainPageModel>(
        stream: Provider.of<DiscoveryMainPageBloc>(context).mainModelState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final rootCategory =
              categoryBloc.repoList.value[snapshot.data.outerPageState];

          var height = 22 * MediaQuery.of(context).textScaleFactor + 102;
          rootCategory.nodes.map((category) {
            if (category.summary.contains('<br>')) {
              height = 42 * MediaQuery.of(context).textScaleFactor + 102;
            }
          }).toList();
          return Container(
              height: height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              color: const Color(0xfff8f8f8),
              child: ListView.builder(
                key: PageStorageKey<String>('${rootCategory.name}'),
                scrollDirection: Axis.horizontal,
                controller: PageController(viewportFraction: 0.38),
                physics: const PageScrollPhysics(),
                itemCount: rootCategory.nodes.length,
                itemBuilder: (context, index) {
                  return _buildChildTab(context, rootCategory.nodes[index],
                      index, index == snapshot.data.innerPageState);
                },
              ));
        });
  }
}
