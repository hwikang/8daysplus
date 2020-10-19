// import 'package:circular_check_box/circular_check_box.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/circular_checkbox_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/list_style_text_widget.dart';

class SelectCouponPage extends StatefulWidget {
  const SelectCouponPage({this.coupons, this.product});

  final List<CouponApplyModel> coupons;
  final OrderInfoProductModel product;

  @override
  _SelectCouponPageState createState() => _SelectCouponPageState();
}

class _SelectCouponPageState extends State<SelectCouponPage> {
  int selectedCouponIndex;

  Widget _buildCouponWidget(
      BuildContext context, CouponApplyModel coupon, int couponIndex) {
    String discountText;
    final formatter = NumberFormat('#,###');
    if (coupon.discountUnit == 'PERCENT') {
      discountText = '${coupon.discountAmount}%';
    } else {
      discountText = '${formatter.format(coupon.discountAmount)}원';
    }
    final expireDateString = coupon.expireDate.replaceAll(RegExp('-'), '.');
    var selected = false;

    if (selectedCouponIndex != null) {
      selected = selectedCouponIndex == couponIndex;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          //최소금액 확인
          if (widget.product.totalPrice < coupon.availableMinPrice) {
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${coupon.availableMinPrice}원 이상 상품에 적용 가능합니다.'),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            selected = !selected;
            if (selected) {
              selectedCouponIndex = couponIndex;
            } else {
              selectedCouponIndex = null;
            }
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: selected ? Colors.black : const Color(0xffeeeeee),
                width: 1),
            borderRadius: BorderRadius.circular(4)),
        // height: 138,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(top: couponIndex != 0 ? 12 : 0),
        child: Column(
          children: <Widget>[
            Row(
              // 선택
              children: <Widget>[
                Container(
                    width: 20,
                    height: 20,
                    child: CircularCheckBoxWiget(
                      isAgreed: selected,
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Text(
                    'D-${coupon.remainDay}',
                    style: TextStyles.black12BoldTextStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(
                    '$expireDateString 까지 ',
                    style: TextStyles.black12TextStyle,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 144,
                        child: Text(
                          coupon.name,
                          style: TextStyles.black18BoldTextStyle,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        discountText,
                        style: TextStyles.orange18BoldTextStyle,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      coupon.summary,
                      style: TextStyles.grey12TextStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(
    BuildContext context,
  ) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
        color: Color(0x0c000000),
        width: 1.0,
      ))),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: BlackButtonWidget(
        onPressed: () {
          if (selectedCouponIndex != null) {
            Navigator.pop<CouponApplyModel>(
                context, widget.coupons[selectedCouponIndex]);
          }
        },
        title: '적용하기',
        isUnabled: selectedCouponIndex == null,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: const HeaderTitleWidget(title: '쿠폰선택'),
      ),
      bottomNavigationBar: _buildApplyButton(context),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.coupons.length,
                  itemBuilder: (context, index) {
                    return _buildCouponWidget(
                        context, widget.coupons[index], index);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '쿠폰 사용 시 주의 사항',
                      style: TextStyles.grey12TextStyle,
                    ),
                    ListStyleTextWidget(
                      text: '쿠폰의 할인율과 대상상품등의 조건이 상이하기 때문에 사용 시 유의하시기 바랍니다.',
                      style: TextStyles.grey12TextStyle,
                    ),
                    ListStyleTextWidget(
                      text: '상품당 쿠폰 1장을 사용할 수 있으며, 다른 쿠폰과 중복 사용이 불가합니다.',
                      style: TextStyles.grey12TextStyle,
                    ),
                    ListStyleTextWidget(
                      text: '주문 후 환불/취소 시 재발급이 불가합니다.',
                      style: TextStyles.grey12TextStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
