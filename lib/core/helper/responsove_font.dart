import 'package:flutter/material.dart';

class ResponsiveFont {
  static double responsiveFont(
    double fontSize, {
    required BuildContext context,
  }) {
    final double scale = getFontScaleFactor(context);
    print(scale);
    final double responsiveFontSize = fontSize * scale;
    final double maxSize = responsiveFontSize * 1.2;
    final double minSize = responsiveFontSize * 0.8;
    return responsiveFontSize.clamp(minSize, maxSize);
  }

  static double getFontScaleFactor(BuildContext context) {
    // PlatformDispatcher dispatcher = PlatformDispatcher.instance;
    // I need physical width and device pixel Ratio
    // var physicalWidth = dispatcher.views.first.physicalSize.width;
    // var devicePixelRation = dispatcher.views.first.devicePixelRatio;
    // var width = physicalWidth / devicePixelRation;
    final double width = MediaQuery.sizeOf(context).width;
    if (width < 600) {
      print("Here Mobile ${width}");
      return width / 450;
    } else {
      print("Here Tablet ${width}");
      return width / 600;
    }
  }
}
