import 'package:flutter/material.dart';

import '../../utils/assets.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';
import '../../utils/text_styles.dart';
import '../components/common/header_title_widget.dart';

class AuthorityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.only(left: 24),
          child: HeaderTitleWidget(
            title: AuthorityPageStrings.authorityTitle,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          children: <Widget>[
            const SizedBox(width: 34),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 42),
              child: Text(
                AuthorityPageStrings.authoritySubTitle,
                maxLines: 2,
                style: TextStyles.black20BoldTextStyle,
              ),
            ),
            // SizedBox(width: 42),
            //storageIcon , locationIcon
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(ImageAssets.storageIcon),
                        width: 42,
                        height: 42,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AuthorityPageStrings.location,
                              style: TextStyles.black14BoldTextStyle,
                            ),
                            Text(
                              AuthorityPageStrings.locationDescription,
                              style: TextStyles.grey14TextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(ImageAssets.locationIcon),
                        width: 42,
                        height: 42,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AuthorityPageStrings.storage,
                              style: TextStyles.black14BoldTextStyle,
                            ),
                            Text(
                              AuthorityPageStrings.storageDescription,
                              style: TextStyles.grey14TextStyle,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(ImageAssets.phoneIcon),
                        width: 42,
                        height: 42,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AuthorityPageStrings.phone,
                              style: TextStyles.black14BoldTextStyle,
                            ),
                            Text(
                              AuthorityPageStrings.phoneDescription,
                              style: TextStyles.grey14TextStyle,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            SafeArea(
                child: Container(
              height: 46,
              margin: const EdgeInsets.only(bottom: 24),
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: FlatButton(
                  color: const Color(0xff404040),
                  child: Text(
                    CommonTexts.confirmButton,
                    style: TextStyles.white14BoldTextStyle,
                  ),
                  onPressed: () async {
                    // AppRoutes.pop(context);
                    // final prefs = await SharedPreferences.getInstance();
                    // prefs.setBool('first', false);
                    AppRoutes.replaceMemberMainPage(context);

                    // AppRoutes.firstMainPage(context);
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
