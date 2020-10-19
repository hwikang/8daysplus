import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.brightness = Brightness.light});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CupertinoTheme(
          data: CupertinoTheme.of(context).copyWith(brightness: brightness),
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class LoadingRingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        child: const Center(child: CupertinoActivityIndicator()));
  }
}
