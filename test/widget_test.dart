import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transportation_app/core/routing/app_router.dart';
import 'package:transportation_app/core/routing/routes.dart';

void main() {
  test('AppRouter creates the onboarding route', () {
    final route = AppRouter().generateRoute(
      const RouteSettings(name: AppRoutes.onBoardingScreen),
    );

    expect(route, isA<MaterialPageRoute<dynamic>>());
  });
}
