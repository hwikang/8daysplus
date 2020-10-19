import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../utils/assets.dart';
import '../../../../utils/routes.dart';
import '../../../../utils/text_styles.dart';
import '../../../components/common/header_title_widget.dart';
import 'delete_user_page.dart';
import 'update_password_page.dart';
import 'update_user_info_page.dart';

class AccountManagePage extends StatelessWidget {
  const AccountManagePage({this.userInfo, this.myPageBloc});

  final MyPageBloc myPageBloc;
  final UserModel userInfo;

  Widget _buildBasicInfo(BuildContext context, UserModel userInfo) {
    Widget icon;
    switch (userInfo.loginType) {
      case 'KAKAO':
        icon = Container(
          margin: const EdgeInsets.only(right: 4),
          child: Image.asset(
            ImageAssets.kakaoYellowIcon,
            width: 20,
          ),
        );
        break;
      case 'GOOGLE':
        icon = Container(
          margin: const EdgeInsets.only(right: 4),
          child: Image.asset(
            ImageAssets.googleIcon,
            width: 20,
          ),
        );
        break;
      case 'APPLE':
        icon = Container(
          margin: const EdgeInsets.only(right: 4),
          child: Image.asset(
            ImageAssets.appleIcon,
            width: 20,
          ),
        );
        break;

      default:
        icon = Container();
    }

    return Column(
      children: <Widget>[
        _buildTitle('기본정보', '비밀번호 변경', () {
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (context) => UpdatePasswordPage()));
        }, userInfo.loginType == 'EMAIL'),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Column(
            children: <Widget>[
              _buildRow(
                '이메일 아이디',
                userInfo.profile.email.isEmpty
                    ? '정보없음'
                    : userInfo.profile.email,
                valueIcon: icon,
              ),
              _buildRow('회사명', userInfo.company.name),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(
      BuildContext context, UserModel userInfo, MyPageBloc myPageBloc) {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      child: Column(
        children: <Widget>[
          _buildTitle('추가정보', '정보수정', () async {
            final bool res = await Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (context) => UpdateUserInfoPage(
                        prevName: userInfo.profile.name,
                        prevBirthDay:
                            '${userInfo.profile.birthYear}${userInfo.profile.birthMonth}${userInfo.profile.birthDay}',
                        prevPhone: userInfo.profile.mobile)));
            if (res != null && res) {
              myPageBloc.fetch(); //정보수정 완료시 fetch 해서 user 업데이트
            }
          }, true),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Column(
              children: <Widget>[
                _buildRow(
                    '이름',
                    userInfo.profile.name.isEmpty
                        ? '정보없음'
                        : userInfo.profile.name),
                _buildRow('생년월일',
                    '${userInfo.profile.birthYear}${userInfo.profile.birthMonth}${userInfo.profile.birthDay}'),
                _buildRow(
                    '휴대폰번호',
                    userInfo.profile.mobile.isEmpty
                        ? '정보없음'
                        : userInfo.profile.mobile)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
      String title, String navText, Function nav, bool showButton) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: TextStyles.black20BoldTextStyle),
        if (showButton)
          GestureDetector(
            onTap: () {
              nav();
            },
            child:
                Text(navText, style: TextStyles.black12BoldUnderlineTextStyle),
          )
        else
          Container(),
      ],
    );
  }

  Widget _buildRow(String key, String value, {Widget valueIcon}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 84,
            margin: const EdgeInsets.only(
              right: 16,
            ),
            child: Text(
              key,
              style: TextStyles.grey14TextStyle,
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                valueIcon ?? Container(),
                Text(
                  value,
                  style: TextStyles.black14TextStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountDeleteNavigator(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (context) => DeleteUserPage()));
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 14,
        ),
        child: Text(
          '회원탈퇴하기',
          style: TextStyles.black12UnderlineTextStyle,
        ),
      ),
    );
  }

  Widget _buildLogoutNavigator(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            // backgroundColor: Colors.white,
            content: Text(
              '정말 로그아웃 하시겠습니까?',
              style: TextStyles.white12TextStyle,
            ),
            action: SnackBarAction(
              label: '예',
              textColor: Colors.white,
              onPressed: () {
                AppRoutes.logout(context);
              },
            ),
          ));
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 14,
        ),
        child: Text(
          '로그아웃',
          style: TextStyles.black12UnderlineTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const HeaderTitleWidget(title: '계정관리'),
        ),
        body: StreamBuilder<UserModel>(
          stream: myPageBloc.userInfo,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return Container();
            }
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  _buildBasicInfo(context, userSnapshot.data),
                  _buildAdditionalInfo(context, userSnapshot.data, myPageBloc),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _buildLogoutNavigator(context),
                        _buildAccountDeleteNavigator(context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
