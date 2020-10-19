import 'package:flutter/material.dart';

import '../../../utils/assets.dart';

class ExpansionTileWidget extends StatefulWidget {
  const ExpansionTileWidget({
    this.title,
    this.trailing,
    this.openedTrailing,
    this.child,
    this.initiallyOpened = false,
    this.onEvent,
  });

  final Widget child;
  final bool initiallyOpened;
  final Widget openedTrailing;
  final Function onEvent;
  final Widget title;
  final Widget trailing;

  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  bool isOpened;

  @override
  void initState() {
    super.initState();
    isOpened = widget.initiallyOpened;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isOpened = !isOpened;
          });
          if (widget.onEvent != null) {
            widget.onEvent();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(right: 24),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.title,
                        Container(
                            child: isOpened
                                ? Image.asset(
                                    ImageAssets.arrowUpImage,
                                    width: 10,
                                  )
                                : Image.asset(
                                    ImageAssets.arrowDownImage,
                                    width: 10,
                                  )),
                      ],
                    ),
                  )),
              if (isOpened) widget.child ?? Container()
            ],
          ),
        ));
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({
    this.title,
    this.child,
    this.onEvent,
  });

  final Widget child;

  final Function onEvent;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onEvent != null) {
            onEvent();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: title,
        ));
  }
}
