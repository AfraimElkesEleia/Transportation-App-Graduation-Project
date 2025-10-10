import 'package:flutter/foundation.dart';

class ResponsoveFont {
  static double responsiveFont(double fontSize) {
    final double scale = getFontScaleFactor();
    final responsiveFontSize = fontSize * scale;
    final double maxSize = responsiveFontSize * 1.2;
    final double minSize = responsiveFontSize * 0.8;
    return responsiveFontSize.clamp(minSize, maxSize);
  }

  static double getFontScaleFactor() {
    PlatformDispatcher dispatcher = PlatformDispatcher.instance;
    // I need physical width and device pixel Ratio
    var physicalWidth = dispatcher.views.first.physicalSize.width;
    var devicePixelRation = dispatcher.views.first.devicePixelRatio;
    var width = physicalWidth / devicePixelRation;
    if (width < 600) {
      return width / 550;
    } else {
      return width / 1000;
    }
  }
}
