import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';

abstract class AppStyles {
  static const semiBold18White = TextStyle(
    color: Colors.white,
    fontWeight: FontWeightHelper.semiBold,
    fontSize: 18,
  );
  static const bold16CyanBlue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorsManager.cyanBlue,
  );
  static const medium32White = TextStyle(
    fontSize: 32,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
  static const regular20CyanBlue = TextStyle(
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.cyanBlue,
    fontSize: 20,
  );
  static const bold18DarkBlue = TextStyle(
    fontWeight: FontWeight.bold,
    color: ColorsManager.darkBlue,
    fontSize: 18,
  );
}
