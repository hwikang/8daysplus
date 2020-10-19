import 'package:flutter/material.dart';

mixin FontFamily {
  static String bold = 'SpoqaBold';
  static String regular = 'Spoqa';
  static String jalnan = 'Jalnan';
}

mixin TextStyles {
  //text 형식 정리
  // 이름 형식 =  색상-사이즈-볼드(아니면 생략)-기타(없으면 생략)-TextStyle

  static TextStyle get white8TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 8,
        color: Colors.white,
      );
  /* 10 */
  static TextStyle get black10TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 10,
        color: const Color(0xff404040),
      );
  static TextStyle get black10BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 10,
        color: const Color(0xff404040),
      );

  static TextStyle get grey10LineThroughTextStyle => TextStyle(
        decoration: TextDecoration.lineThrough,
        fontFamily: FontFamily.regular,
        fontSize: 10,
        color: Colors.grey,
      );
  static TextStyle get white10TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 10,
        color: Colors.white,
      );
  static TextStyle get orange10TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 10,
        color: const Color(0xffff8c2c),
      );
  /* 11 */
  static TextStyle get orange11TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 11,
        color: const Color(0xffff8c2c),
      );
  /* 12 */
  static TextStyle get black12TextStyle => TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: 12,
      color: const Color(0xff404040));

  static TextStyle get black12BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 12,
        color: const Color(0xff404040),
      );
  static TextStyle get black12UnderlineTextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        decoration: TextDecoration.underline,
        fontSize: 12,
        color: const Color(0xff404040),
      );
  static TextStyle get black12BoldUnderlineTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        decoration: TextDecoration.underline,
        fontSize: 12,
        color: const Color(0xff404040),
      );
  static TextStyle get grey12BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 12,
        color: const Color(0xff909090),
      );
  static TextStyle get grey12TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 12,
        color: const Color(0xff909090),
      );

  static TextStyle get grey12BoldUnderlineTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        decoration: TextDecoration.underline,
        fontSize: 12,
        color: const Color(0xff909090),
      );
  static TextStyle get grey12LineThroughTextStyle => TextStyle(
        decoration: TextDecoration.lineThrough,
        fontFamily: FontFamily.regular,
        fontSize: 12,
        color: Colors.grey,
      );
  static TextStyle get white12TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 12,
        color: Colors.white,
      );
  static TextStyle get white12BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 12,
        color: Colors.white,
      );
  static TextStyle get cyan12TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 12,
        color: const Color(0xff619cca),
      );

  static TextStyle get orange12TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 12,
        color: const Color(0xffff7500),
      );
  static TextStyle get orange12BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 12,
        color: const Color(0xffff7500),
      );
  /* 13 */
  static TextStyle get black13TextStyle => TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: 13,
      color: const Color(0xff404040));

  static TextStyle get black13BoldTextStyle => TextStyle(
      fontFamily: FontFamily.bold,
      fontSize: 13,
      color: const Color(0xff404040));
  /* 14 */
  static TextStyle get black14TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xff404040),
      );
  static TextStyle get black14BoldTextStyle => TextStyle(
      fontFamily: FontFamily.bold,
      fontSize: 14,
      color: const Color(0xff404040));

  static TextStyle get white14TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: Colors.white,
      );
  static TextStyle get white14BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 14,
        color: Colors.white,
      );

  static TextStyle get grey14TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xff909090),
      );
  static TextStyle get grey14UnderlineTextStyle => TextStyle(
        decoration: TextDecoration.underline,
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xff909090),
      );
  static TextStyle get grey14LineThroughTextStyle => TextStyle(
        decoration: TextDecoration.lineThrough,
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xff909090),
      );

  static TextStyle get orange14TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xffff7500),
      );
  static TextStyle get orange14BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 14,
        color: const Color(0xffff7500),
      );
  static TextStyle get red14TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 14,
        color: const Color(0xffff4242),
      );
  /* 15 */
  static TextStyle get black15TextStyle => TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: 15,
      color: const Color(0xff404040));

  static TextStyle get grey15TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 15,
        color: const Color(0xff909090),
      );
  /* 16 */
  static TextStyle get black16TextStyle => TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: 16,
      color: const Color(0xff404040));

  static TextStyle get black16BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 16,
        color: const Color(0xff404040),
      );

  static TextStyle get grey16TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 16,
        color: const Color(0xff909090),
      );

  static TextStyle get grey16BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 16,
        color: const Color(0xff909090),
      );
  static TextStyle get white16TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 16,
        color: Colors.white,
      );
  static TextStyle get white16BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 16,
        color: Colors.white,
      );

  static TextStyle get orange16TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 16,
        color: const Color(0xffff7500),
      );
  static TextStyle get orange16BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 16,
        color: const Color(0xffff7500),
      );
  static TextStyle get grey16UnderlineTextStyle => TextStyle(
      fontFamily: FontFamily.regular,
      fontSize: 16,
      color: const Color(0xff909090),
      decoration: TextDecoration.underline);

  /* 18 */
  static TextStyle get black18TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 18,
        color: const Color(0xff404040),
      );
  static TextStyle get black18BoldTextStyle => TextStyle(
      fontFamily: FontFamily.bold,
      fontSize: 18,
      color: const Color(0xff404040));
  static TextStyle get white18BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 18,
        color: Colors.white,
      );
  static TextStyle get orange18TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 18,
        color: const Color(0xffff8c2c),
      );

  static TextStyle get orange18BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 18,
        color: const Color(0xffff7500),
      );

  /* 19 */
  static TextStyle get black19BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 19,
        color: const Color(0xff404040),
      );
  /* 20 */
  static TextStyle get black20BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 20,
        color: const Color(0xff404040),
      );

  static TextStyle get white20BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 20,
        color: const Color(0xffffffff),
      );
  static TextStyle get grey20TextStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: 20,
        color: const Color(0xff909090),
      );
  static TextStyle get orange20BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 20,
        color: const Color(0xffff7500),
      );
  /* 22 */
  static TextStyle get black22BoldTextStyle => TextStyle(
      fontFamily: FontFamily.bold,
      fontSize: 22,
      color: const Color(0xff404040));
  static TextStyle get black24BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 24,
        color: const Color(0xff404040),
      );

  static TextStyle get white28BoldTextStyle => TextStyle(
        fontFamily: FontFamily.bold,
        fontSize: 28,
        color: Colors.white,
      );

/////////////////////////////////
  ///
/////////////////////////////////
  ///
/////////////////////////////////
  ///
///////////////////////////////// 추후 삭제예정
  static TextStyle get jalnanTitleTextStyle => TextStyle(
      fontFamily: FontFamily.jalnan, fontSize: 28, color: Colors.white);
}
