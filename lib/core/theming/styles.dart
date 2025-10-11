import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/responsove_font.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';

abstract class AppStyles {
  static TextStyle semiBold18White(BuildContext context) => TextStyle(
    color: Colors.white,
    fontWeight: FontWeightHelper.semiBold,
    fontSize: ResponsiveFont.responsiveFont(18, context: context),
  );

  static TextStyle bold16CyanBlue(BuildContext context) => TextStyle(
    fontSize: ResponsiveFont.responsiveFont(16, context: context),
    fontWeight: FontWeight.bold,
    color: ColorsManager.cyanBlue,
  );

  static TextStyle medium32White(BuildContext context) => TextStyle(
    fontSize: ResponsiveFont.responsiveFont(32, context: context),
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle regular16CyanBlue(BuildContext context) => TextStyle(
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.cyanBlue,
    fontSize: ResponsiveFont.responsiveFont(16, context: context),
  );

  static TextStyle bold18DarkBlue(BuildContext context) => TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorsManager.darkBlue,
    fontSize: ResponsiveFont.responsiveFont(18, context: context),
  );
}