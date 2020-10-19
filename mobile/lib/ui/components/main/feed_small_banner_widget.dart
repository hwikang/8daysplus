import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../utils/action_link.dart';
import '../../../utils/device_ratio.dart';

class FeedSmallBannerWidget extends StatelessWidget {
  const FeedSmallBannerWidget({this.bannerList});

  final List<FeedBannerModel> bannerList;

  @override
  Widget build(BuildContext context) {
    if (bannerList.isEmpty) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        final al = ActionLink();
        al.handleActionLink(context, bannerList[0].actionLink, '');
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffeeeeee), width: 1),
            borderRadius: BorderRadius.circular(8)),
        height: 78 * DeviceRatio.scaleHeight(context),
        width: 312 * DeviceRatio.scaleWidth(context),
        margin: const EdgeInsets.only(
          bottom: 48,
          left: 24,
          right: 24,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: bannerList[0].coverImage.url,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
