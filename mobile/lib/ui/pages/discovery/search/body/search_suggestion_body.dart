import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/assets.dart';
import '../../../../../utils/routes.dart';
import '../../../../../utils/text_styles.dart';

class SearchSuggestionBody extends StatefulWidget {
  const SearchSuggestionBody({this.results, this.textController});

  final SearchKeywordModel results;
  final TextEditingController textController;

  @override
  SearchSuggestionBodyState createState() => SearchSuggestionBodyState();
}

class SearchSuggestionBodyState extends State<SearchSuggestionBody> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildList(String title) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 24,
            child: Image(image: AssetImage(ImageAssets.searchResultIcon)),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              child: _titleBuild(title, widget.textController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBuild(String title, String standard) {
    if (standard != '') {
      final splitTitle = title.toUpperCase().split(standard.toUpperCase());

      return RichText(
        text: TextSpan(
          style: TextStyles.grey14TextStyle,
          children: <TextSpan>[
            TextSpan(text: splitTitle[0]),
            TextSpan(
                text: standard,
                style: const TextStyle(
                  color: Color(0xffff7500),
                )),
            TextSpan(text: splitTitle[1]),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      title,
      style: TextStyles.black14TextStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchBodyBloc = Provider.of<SearchStateBloc>(context);
    final searchListBloc = Provider.of<SearchListBloc>(context);
    final recentKeywordList = widget.results.recentKeywords;
    if (widget.textController.text == '') {
      return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (recentKeywordList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '최근 검색',
                        style: TextStyles.grey12TextStyle,
                      ),
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: widget.results.recentKeywords.map((data) {
                          return GestureDetector(
                            onTap: () {
                              // searchListBloc.changeKeyword(data);
                              searchListBloc.search(
                                keyword: data,
                              );
                              searchBodyBloc
                                  .changeBodyState(SearchBodyState.Result);
                            },
                            child: _buildList(data),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                else
                  Container(),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  '인기 키워드',
                  style: TextStyles.grey12TextStyle,
                ),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: widget.results.bestKeywords.map((data) {
                    return GestureDetector(
                      onTap: () {
                        searchListBloc.search(keyword: data);
                        searchBodyBloc.changeBodyState(SearchBodyState.Result);
                      },
                      child: _buildList(data),
                    );
                  }).toList(),
                )
              ],
            )),
      );
    } else {
      final queryProducts = widget.results.products
          .where((data) => data.name
              .toLowerCase()
              .contains(widget.textController.text ?? ''))
          .toList();

      return Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24,
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: queryProducts.map((data) {
            return GestureDetector(
              onTap: () {
                AppRoutes.productDetailPage(context, data);
              },
              child: _buildList(data.name),
            );
          }).toList(),
        ),
      );
    }
  }
}
