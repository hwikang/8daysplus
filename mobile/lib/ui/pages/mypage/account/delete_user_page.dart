import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/button/black_button_widget.dart';
import '../../../components/common/circular_checkbox_widget.dart';
import '../../../components/common/header_title_widget.dart';
import '../../../components/common/loading_widget.dart';
import '../../../modules/common/handle_network_module.dart';
import 'delete_user_confirm_page.dart';

class DeleteUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DeleteUserBloc>(
      create: (context) => DeleteUserBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
              color: Colors.black,
            ),
          ),
          title: const HeaderTitleWidget(
              title: MyPageStrings.withdraw_screentitle_withdraw),
        ),
        bottomNavigationBar: DeleteUserBottom(),
        body: DeleteUserBody(),
      ),
    );
  }
}

class DeleteUserBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: Provider.of<DeleteUserBloc>(context).isAgreed,
        builder: (context, isAgreedsnapshot) {
          bool isUnabled;
          if (!isAgreedsnapshot.hasData) {
            isUnabled = false;
          } else {
            isUnabled = !isAgreedsnapshot.data;
          }
          print(isAgreedsnapshot.data);
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              // height: 48,
              width: MediaQuery.of(context).size.width,
              child: BlackButtonWidget(
                isUnabled: isUnabled,
                title: MyPageStrings.common_btn_withdraw,
                onPressed: () {
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (context) => DeleteUserConfirmPage()));
                  // DeleteUserProvider deleteUserProvider =
                  //     DeleteUserProvider();
                  // DialogWidget dialogWidget = DialogWidget();
                  // dialogWidget.buildDialog(
                  //   context: context,
                  //     title: '정말?',
                  //     buttonTitle: '예',
                  //     onPressed: () {});
                },
              ),
            ),
          );
        });
  }
}

class DeleteUserBody extends StatelessWidget {
  Widget _buildTexts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '8DAYS+를 탈퇴하겠습니까?',
          style: TextStyles.black20BoldTextStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(MyPageStrings.withdraw_title_wantleave,
            style: TextStyles.black16TextStyle),
      ],
    );
  }

  Widget _buildPointCouponContainer(
      BuildContext context, int lifePoint, int couponCount) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: EdgeInsets.all(20 * MediaQuery.of(context).textScaleFactor),
      // height: 88 * MediaQuery.of(context).textScaleFactor,
      color: const Color(0xfff8f8f8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                MyPageStrings.withdraw_contents_holdingpoint,
                style: TextStyles.black14TextStyle,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                '${lifePoint}P',
                style: TextStyles.black14BoldTextStyle,
              )
            ],
          ),
          SizedBox(
            height: 8 * MediaQuery.of(context).textScaleFactor,
          ),
          Row(
            children: <Widget>[
              Text(
                MyPageStrings.withdraw_contents_holdingcoupon,
                style: TextStyles.black14TextStyle,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                '$couponCount개',
                style: TextStyles.black14BoldTextStyle,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckBox(BuildContext context) {
    final deleteUserBloc = Provider.of<DeleteUserBloc>(context);

    return GestureDetector(
      onTap: () {
        print('toggle');
        deleteUserBloc.toggleAgreeState();
      },
      child: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<bool>(
                stream: Provider.of<DeleteUserBloc>(context).isAgreed,
                builder: (context, isAgreedsnapshot) {
                  return CircularCheckBoxWiget(
                    isAgreed: isAgreedsnapshot.data ?? false,
                  );
                }),
            Expanded(
              child: Text(
                MyPageStrings.withdraw_contents_check,
                style: TextStyles.black14TextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<DeleteUserBloc>(context);

    return HandleNetworkModule(
      networkState: bloc.networkState,
      retry: bloc.fetch,
      child: StreamBuilder<Map<String, dynamic>>(
          stream: Provider.of<DeleteUserBloc>(context).pointCouponState,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingRingWidget();
            }
            return Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTexts(context),
                    _buildPointCouponContainer(
                        context,
                        snapshot.data['lifePoint'],
                        snapshot.data['couponCount']),
                    const SizedBox(
                      height: 24,
                    ),
                    _buildCheckBox(context),
                    Expanded(
                      child: Container(),
                    ),
                    // StreamBuilder<bool>(
                    //     stream: Provider.of<DeleteUserBloc>(context).isAgreed,
                    //     builder: (context, AsyncSnapshot<bool> isAgreedsnapshot) {
                    //       bool isUnabled;
                    //       if (!isAgreedsnapshot.hasData) {
                    //         isUnabled = false;
                    //       } else {
                    //         isUnabled = !isAgreedsnapshot.data;
                    //       }
                    //       print(isAgreedsnapshot.data);
                    //       return Container(
                    //         height: 48,
                    //         width: MediaQuery.of(context).size.width,
                    //         child: BlackButtonWidget(
                    //           isUnabled: isUnabled,
                    //           title: MyPageStrings.common_btn_withdraw,
                    //           onPressed: () {
                    //             Navigator.push<dynamic>(
                    //                 context,
                    //                 MaterialPageRoute<dynamic>(
                    //                     builder: (BuildContext context) =>
                    //                         DeleteUserConfirmPage()));
                    //             // DeleteUserProvider deleteUserProvider =
                    //             //     DeleteUserProvider();
                    //             // DialogWidget dialogWidget = DialogWidget();
                    //             // dialogWidget.buildDialog(
                    //             //   context: context,
                    //             //     title: '정말?',
                    //             //     buttonTitle: '예',
                    //             //     onPressed: () {});
                    //           },
                    //         ),
                    //       );
                    //     }),
                  ],
                ));
          }),
    );
  }
}
