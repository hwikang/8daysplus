import 'package:flutter/widgets.dart';

class CupertinoExtIcons {
  CupertinoExtIcons._();

  // Manually maintained list.

  /// A thin left chevron.
  static const IconData home = IconData(0xf38f,
      fontFamily: iconFont,
      fontPackage: iconFontPackage,
      matchTextDirection: true);

  /// The icon font used for Cupertino icons.
  static const String iconFont = 'CupertinoIcons';

  /// The dependent package providing the Cupertino icons font.
  static const String iconFontPackage = 'cupertino_icons';
}
