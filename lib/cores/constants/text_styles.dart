import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  TextStyles._();

  static late TextStyle coreStyle;

  static TextStyle normal = GoogleFonts.roboto().copyWith(
    fontSize: TextSizeDimens.normal,
    color: TextColors.main,
    // height: 1.2,
  );

  static TextStyle bold = normal.copyWith(
    fontWeight: FontWeight.w700,
  );

  static TextStyle underline = normal.copyWith(
    decoration: TextDecoration.underline,
  );

  static TextStyle small = normal.copyWith(
    fontSize: TextSizeDimens.small,
  );

  static TextStyle smallBold = bold.copyWith(
    fontSize: TextSizeDimens.small,
  );

  static TextStyle smallUnderline = underline.copyWith(
    fontSize: TextSizeDimens.small,
  );

  static TextStyle medium = normal.copyWith(
    fontSize: TextSizeDimens.medium,
  );

  static TextStyle mediumBold = bold.copyWith(
    fontSize: TextSizeDimens.medium,
  );

  static TextStyle mediumItalic = normal.copyWith(
    fontStyle: FontStyle.italic,
  );

  static TextStyle large = normal.copyWith(
    fontSize: TextSizeDimens.large,
  );
  static TextStyle largeBold = bold.copyWith(
    fontSize: TextSizeDimens.large,
  );

  static TextStyle extra = normal.copyWith(
    fontSize: TextSizeDimens.extra,
  );
  static TextStyle extraBold = bold.copyWith(
    fontSize: TextSizeDimens.extra,
  );

  static TextStyle normalTimes = TextStyle(
    fontFamily: 'TimesNewRoman',
    fontSize: TextSizeDimens.normal,
    color: TextColors.main,
  );
  static TextStyle boldTimes = normalTimes.copyWith(
    fontWeight: FontWeight.w600,
  );
  static TextStyle mediumBoldTimes = boldTimes.copyWith(
    fontSize: TextSizeDimens.medium,
  );
  static TextStyle largeTimes = normalTimes.copyWith(
    fontSize: TextSizeDimens.large,
  );
  static TextStyle largeBoldTimes = boldTimes.copyWith(
    fontSize: TextSizeDimens.large,
  );
}
