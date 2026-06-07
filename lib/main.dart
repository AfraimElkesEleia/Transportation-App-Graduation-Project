import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/notfications/notfication_permission_manager.dart';
import 'package:transportation_app/core/routing/app_router.dart';
import 'package:transportation_app/core/routing/navigator_key.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/utils/app_startup.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/search/data/models/recent_search_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transportation_app/core/notfications/fcm_service.dart';
import 'package:transportation_app/core/notfications/notfication_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/locale_box.dart';
import 'package:transportation_app/core/l10n/locale_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(RecentSearchModelAdapter());
  await Hive.openBox<RecentSearchModel>('recent_searches_box');

  await Firebase.initializeApp();
  await FcmService.init();
  await NotficationService.init();
  await Hive.openBox(LocaleBox.boxName);
  await init();
  final tokenManager = sl<TokenManager>();
  final startup = AppStartup(tokenManager);
  final isLoggedIn = await startup.isUserLoggedIn();
  debugPrint('$isLoggedIn');
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
    return BlocProvider<LocaleCubit>(
      create: (_) => sl<LocaleCubit>()..init(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => NotficationPermissionGate(
            child: child ?? const SizedBox.shrink(),
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
