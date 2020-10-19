import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/assets.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/text_styles.dart';
import '../common/dash_widget.dart';
import '../common/dialog_widget.dart';
import '../common/product-list/list_title_widget.dart';

class FeedCouponWidget extends StatelessWidget {
  const FeedCouponWidget({
    this.title,
    this.couponList,
  });

  final List<FeedCouponModel> couponList;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (couponList.isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(
          bottom: 48,
        ),
        child: Column(
          children: <Widget>[
            ListTitleWidget(title: title),
            const SizedBox(height: 16),
            CouponListWidget(
              couponList: couponList,
            ),
          ],
        ));
  }
}

class CouponListWidget extends StatelessWidget {
  const CouponListWidget({
    this.couponList,
  });

  final List<FeedCouponModel> couponList;

  @override
  Widget build(BuildContext context) {
    if (!couponList.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: ListView.builder(
            key: PageStorageKey(UniqueKey()),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: couponList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.0, color: const Color(0xffeeeeee)),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: buildCouponCard(context, index, couponList),
              );
            }),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }
}

Widget buildCouponCard(
    BuildContext context, int i, List<FeedCouponModel> couponList) {
  final _debouncer = Debouncer(milliseconds: 100);
  var unit = '';
  if (couponList[i].discountUnit == 'PERCENT') {
    unit = '%';
  } else {
    unit = '원';
  }
  final summary = couponList[i].summary;
  if (summary.contains('<br>')) {
    final result = summary.replaceAll('<br>', '\n');
    couponList[i].summary = result;
  }
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                couponList[i].name,
                style: TextStyles.orange11TextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Container(
                height: 36 * MediaQuery.of(context).textScaleFactor,
                child: Text(
                  '${couponList[i].discountAmount} $unit',
                  style: TextStyles.black24BoldTextStyle,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 18 * MediaQuery.of(context).textScaleFactor,
                child: Text(
                  couponList[i].summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.grey12TextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        child: Dash(
            direction: Axis.vertical,
            length: 118 * MediaQuery.of(context).textScaleFactor - 2,
            dashLength: 4,
            dashGap: 3,
            dashColor: const Color(0xffe0e0e0),
            dashBorderRadius: 4,
            dashThickness: 1),
      ),
      Container(
        child: SizedBox(
          width: 70,
          // height: 130 * DeviceRatio.scaleHeight(context),
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              AppRoutes.authCheck(context).then((isLogin) {
                _debouncer.run(() {
                  if (isLogin) {
                    final applyCouponBloc = ApplyCouponBloc();
                    applyCouponBloc.getCoupon(couponList[i].id).then((value) {
                      DialogWidget.showAlert(
                          context: context, child: Text(value.message));
                    }).catchError((error) {
                      if (error.contains('error_msg')) {
                        final Map<String, dynamic> map = json.decode(error);

                        DialogWidget.showAlert(
                            context: context, child: Text(map['error_msg']));
                      } else {
                        DialogWidget.showAlert(
                            context: context, child: Text(error));
                      }
                    });
                  } else {
                    DialogWidget.showAlert(
                      context: context,
                      child: const Text(ErrorTexts.needLogin),
                    );
                  }
                });
              });
            },
            child: Image.asset(
              ImageAssets.contentDownImage,
              width: 16,
              height: 16,
            ),
          ),
        ),
      ),
    ],
  );
}
