// import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';

import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/circular_checkbox_widget.dart';
import '../../../components/common/header_title_widget.dart';

class SelectRefundReasonPage extends StatefulWidget {
  @override
  _SelectRefundReasonPageState createState() => _SelectRefundReasonPageState();
}

class _SelectRefundReasonPageState extends State<SelectRefundReasonPage> {
  String reason;
  List<String> reasonList = <String>[
    '환불 사유	여행이 취소되거나 미뤄졌습니다.',
    '실수로 구매했습니다.',
    '구매했지만 상품을 받지 못했습니다.',
    '친구나 가족이 내 동의 없이 구매했습니다.',
  ];

  int selectedCheckboxIndex;

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    selectedCheckboxIndex = 0;
    reason = reasonList[0];
    _textEditingController = TextEditingController();
  }

  Widget _buildCheckbox(int index, String title) {
    return GestureDetector(
      onTap: () {
        if (selectedCheckboxIndex != index) {
          setState(() {
            selectedCheckboxIndex = index;
            reason = title;
          });
        } else {
          selectedCheckboxIndex = null;
          reason = '';
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 5),
              width: 26,
              height: 26,
              child: CircularCheckBoxWiget(
                isAgreed: selectedCheckboxIndex == index,
              ),
            ),
            Text(
              title,
              style: TextStyles.black14TextStyle,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
          title: const HeaderTitleWidget(title: '환불사유'),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width,
            child: BlackButtonWidget(
              title: '등록',
              onPressed: () {
                Navigator.pop(context, reason);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              children: <Widget>[
                _buildCheckbox(0, reasonList[0]),
                _buildCheckbox(1, reasonList[1]),
                _buildCheckbox(2, reasonList[2]),
                _buildCheckbox(3, reasonList[3]),
                _buildCheckbox(4, '직접입력'),
                if (selectedCheckboxIndex == 4)
                  Container(
                    // height: 400,
                    child: TextField(
                      enabled: selectedCheckboxIndex == 4,
                      maxLength: 150,
                      maxLines: 4,
                      controller: _textEditingController,
                      onChanged: (text) {
                        setState(() {
                          reason = text;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: '최대 150자까지 입력 가능',
                        // contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffe0e0e0),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
