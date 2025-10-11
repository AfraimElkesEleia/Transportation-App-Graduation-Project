import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/responsove_font.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';

abstract class AppStyles {
  static final semiBold18White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeightHelper.semiBold,
    fontSize: ResponsiveFont.responsiveFont(18),
  );
  static final bold16CyanBlue = TextStyle(
    fontSize: ResponsiveFont.responsiveFont(16),
    fontWeight: FontWeight.bold,
    color: ColorsManager.cyanBlue,
  );
  static final medium32White = TextStyle(
    fontSize: ResponsiveFont.responsiveFont(32),
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
  static final regular16CyanBlue = TextStyle(
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.cyanBlue,
    fontSize: ResponsiveFont.responsiveFont(16),
  );
  static final bold18DarkBlue = TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorsManager.darkBlue,
    fontSize: ResponsiveFont.responsiveFont(18),
  );
}
