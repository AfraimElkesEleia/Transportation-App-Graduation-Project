import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/routing/app_router.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/utils/app_startup.dart';
import 'package:transportation_app/core/utils/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  final tokenManager = sl<TokenManager>();
  final startup = AppStartup(tokenManager);
  final isLoggedIn = await startup.isUserLoggedIn();
  print(isLoggedIn);
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => TransportationApp(
        appRouter: AppRouter(),
        initialRoute: isLoggedIn
            ? AppRoutes.homeScreen
            : AppRoutes.onBoardingScreen,
      ),
    ),
  );
}

class TransportationApp extends StatelessWidget {
  final AppRouter appRouter;
  final String initialRoute;
  const TransportationApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
