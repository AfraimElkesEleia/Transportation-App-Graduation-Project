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
  static TextStyle regular18white(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: ResponsiveFont.responsiveFont(18, context: context),
  );

  // Screen titles (e.g. "Profile", "Ticket Marketplace")
  static TextStyle bold20White(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: ResponsiveFont.responsiveFont(20, context: context),
    fontWeight: FontWeight.bold,
  );

  // Subtitles (e.g. "Manage your account")
  static TextStyle regular13White70(BuildContext context) => TextStyle(
    color: Colors.white70,
    fontSize: ResponsiveFont.responsiveFont(13, context: context),
  );

  // Card header names
  static TextStyle bold18White(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: ResponsiveFont.responsiveFont(18, context: context),
    fontWeight: FontWeight.bold,
  );

  // Card secondary text
  static TextStyle regular14White70(BuildContext context) => TextStyle(
    color: Colors.white70,
    fontSize: ResponsiveFont.responsiveFont(14, context: context),
  );

  // Stat values
  static TextStyle bold16White(BuildContext context) => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: ResponsiveFont.responsiveFont(16, context: context),
  );

  // Stat / info labels
  static TextStyle regular12White70(BuildContext context) => TextStyle(
    color: Colors.white70,
    fontSize: ResponsiveFont.responsiveFont(12, context: context),
  );

  // Action tile titles
  static TextStyle regular15White(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: ResponsiveFont.responsiveFont(15, context: context),
  );

  // Discounted prices
  static TextStyle bold16SuccessGreen(BuildContext context) => TextStyle(
    color: ColorsManager.successGreen,
    fontWeight: FontWeight.bold,
    fontSize: ResponsiveFont.responsiveFont(16, context: context),
  );

  // Info column labels (e.g. "Seat", "Class")
  static TextStyle regular12White60(BuildContext context) => TextStyle(
    color: Colors.white60,
    fontSize: ResponsiveFont.responsiveFont(12, context: context),
  );
}
