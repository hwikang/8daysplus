import 'package:flutter/material.dart';

@immutable
class ImageProperties {
  const ImageProperties({
    this.scale = 1,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.filterQuality = FilterQuality.low,
  });

  final AlignmentGeometry alignment;
  final Rect centerSlice;
  final Color color;
  final BlendMode colorBlendMode;
  final bool excludeFromSemantics;
  final FilterQuality filterQuality;
  final BoxFit fit;
  final double height;
  final bool matchTextDirection;
  final ImageRepeat repeat;
  final double scale;
  final String semanticLabel;
  final double width;
}
