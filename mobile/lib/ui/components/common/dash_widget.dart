import 'package:flutter/material.dart';

class Dash extends StatelessWidget {
  const Dash(
      {Key key,
      this.direction = Axis.horizontal,
      this.dashColor = Colors.black,
      this.length = 300,
      this.dashGap = 3,
      this.dashLength = 6,
      this.dashThickness = 1,
      this.dashBorderRadius = 0})
      : super(key: key);

  final double dashBorderRadius;
  final Color dashColor;
  final double dashGap;
  final double dashLength;
  final double dashThickness;
  final Axis direction;
  final double length;

  Widget step(int index, double newDashGap) {
    final isHorizontal = direction == Axis.horizontal;
    return Padding(
        padding: EdgeInsets.fromLTRB(
            0,
            0,
            isHorizontal && index != 1 ? newDashGap : 0,
            isHorizontal || index == 1 ? 0 : newDashGap),
        child: SizedBox(
          width: isHorizontal ? dashLength : dashThickness,
          height: isHorizontal ? dashThickness : dashLength,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: dashColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(dashBorderRadius))),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final dashes = <Widget>[];
    final n = (length + dashGap) / (dashGap + dashLength);
    final newN = n.round();
    final newDashGap = (length - dashLength * newN) / (newN - 1);
    for (var i = newN; i > 0; i--) {
      dashes.add(step(i, newDashGap));
    }
    if (direction == Axis.horizontal) {
      return SizedBox(
          width: length,
          child: Row(
            children: dashes,
          ));
    } else {
      return Column(children: dashes);
    }
  }
}
