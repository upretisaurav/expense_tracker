import 'package:flutter/material.dart';

import 'color_styles.dart';

abstract class TextStyles {
  static const humongous = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w800,
    color: ColorStyles.primaryTextColor,
  );

  static const h1 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    color: ColorStyles.primaryTextColor,
  );

  static const body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: ColorStyles.primaryTextColor,
  );

  static const bodyBold = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w800,
    color: ColorStyles.primaryTextColor,
  );

  static const bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: ColorStyles.primaryTextColor,
  );

  static const smallMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: ColorStyles.primaryTextColor,
  );

  static const xSmallMedium = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    color: ColorStyles.primaryTextColor,
  );
}
