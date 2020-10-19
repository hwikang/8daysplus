import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/device_ratio.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var offset = 0;
    var time = 800;

    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: const ShimmerLayout(),
                period: Duration(milliseconds: time),
              ));
        },
      ),
    );
  }
}

class ShimmerShortList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[300],
              child: const ShimmerLayout(
                containerHeight: 15,
                containerWidth: 230,
              ),
            ),
          );
        });
  }
}

class ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600 *
          DeviceRatio.scaleHeight(
              context), //높이 지정 해주지않으면 gridview 에러발생(non-finite rect)
      child: GridView.builder(
          // key: PageStorageKey<String>(
          //     'customGridListItem-$heroTagName'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.75,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
                child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[300],
              child: const ShimmerGridLayout(),
            ));
          }),
    );
  }
}

class ShimmerGridLayout extends StatelessWidget {
  const ShimmerGridLayout({
    this.imageWidth = 150,
    this.imageHeight = 112,
    this.containerHeight = 15,
    this.containerWidth = 150,
  });

  final double containerHeight;
  final double containerWidth;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: imageWidth,
            height: imageHeight,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: containerHeight,
            width: containerWidth,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            height: containerHeight,
            width: containerWidth * 0.5,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            height: containerHeight,
            width: containerWidth * 0.8,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  const ShimmerLayout({
    this.containerHeight = 15,
    this.containerWidth = 230,
  });

  final double containerHeight;
  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 96,
            width: 96,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ShimmerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 500,
        child: Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.white,
          child: Image.asset('thecsguy.PNG'),
          period: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
