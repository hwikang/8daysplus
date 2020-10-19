import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/device_ratio.dart';
import '../../../utils/text_styles.dart';
import '../common/product-list/list_title_widget.dart';

//It's in my style page
class FeedSummaryWidget extends StatelessWidget {
  const FeedSummaryWidget({this.node});

  final Map<String, dynamic> node;

  @override
  Widget build(BuildContext context) {
    //4개씩 나눔 - 리스트 [[],[],[]] ;
    final List<FeedSummaryModel> feedSummary = node['feedSummary'];
    final list = <List<FeedSummaryModel>>[];
    final rowNum = (feedSummary.length / 4).ceil(); //줄 갯수
    for (var i = 0; i < rowNum; i++) {
      list.add(feedSummary.sublist(i * 4, (i + 1) * 4)); //0-4 4-8 8-12 이렇게 들어감
    }
    print(list);
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTitleWidget(
              title: node['title'],
            ),
            const SizedBox(height: 14),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffeeeeee), width: 1)),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rowNum * 2 - 1,
                itemBuilder: (context, listIndex) {
                  if (listIndex.isOdd) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Divider(
                        thickness: 1,
                        color: Color(0xffeeeeee),
                      ),
                    );
                  }
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: 62 * MediaQuery.of(context).textScaleFactor,
                      minHeight: 40.0,
                    ),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: list[listIndex ~/ 2].length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 68 * DeviceRatio.scaleWidth(context),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${list[listIndex ~/ 2][index].score}',
                                  style: TextStyles.black18BoldTextStyle,
                                ),
                                Text(
                                  '${list[listIndex ~/ 2][index].name}',
                                  style: TextStyles.grey12TextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
