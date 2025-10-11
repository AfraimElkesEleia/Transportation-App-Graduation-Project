import 'package:flutter/foundation.dart';

class ResponsiveFont {
  static double responsiveFont(double fontSize) {
    final double scale = getFontScaleFactor();
    print(scale);
    final double responsiveFontSize = fontSize * scale;
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
      print("Here Mobile ${width}");
      return width / 450;
    } else {
      print("Here Tablet ${width}");
      return width / 700;
    }
  }
}
