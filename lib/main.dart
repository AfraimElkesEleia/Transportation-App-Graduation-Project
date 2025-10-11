import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/core/routing/app_router.dart';
import 'package:transportation_app/core/routing/routes.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => TransportationApp(appRouter: AppRouter()),
    ),
  );
}

class TransportationApp extends StatelessWidget {
  final AppRouter appRouter;
  const TransportationApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: AppRoutes.onBoardingScreen,
    );
  }
}
