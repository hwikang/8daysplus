import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../utils/action_link.dart';
import '../../../utils/device_ratio.dart';

class FeedBannerWidget extends StatelessWidget {
  const FeedBannerWidget({
    this.bannerList,
  });

  final List<FeedBannerModel> bannerList;

  Widget _buildBanner(BuildContext context, FeedBannerModel banner) {
    return GestureDetector(
      onTap: () {
        final al = ActionLink();
        al.handleActionLink(context, banner.actionLink, '');
      },
      child: Container(
          child: CachedNetworkImage(
        imageUrl: banner.coverImage.url,
        fit: BoxFit.fill,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bannerList.isEmpty) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 48),
        width: 360 * DeviceRatio.scaleWidth(context),
        height: 202 * DeviceRatio.scaleWidth(context),
        child: Swiper(
          key: PageStorageKey<String>('FeedBannerWidget-${bannerList[0].id}'),
          itemCount: bannerList.length,
          autoplay: false,
          itemBuilder: (context, index) {
            return _buildBanner(context, bannerList[index]);
          },
        ));
  }
}
