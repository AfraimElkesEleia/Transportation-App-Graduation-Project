import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'locale_box.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  /// Called at startup — reads Hive, falls back to device locale, and syncs
  Future<void> init() async {
    final box = Hive.box(LocaleBox.boxName);
    final saved = box.get(LocaleBox.localeKey) as String?;
    if (saved != null) {
      emit(Locale(saved));
      await syncLanguageWithBackend();
      return;
    }
    // First launch → detect device locale
    final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final lang = deviceLang == 'ar' ? 'ar' : 'en';
    await box.put(LocaleBox.localeKey, lang);
    emit(Locale(lang));
    await syncLanguageWithBackend();
  }

  Future<void> setLocale(String code) async {
    await Hive.box(LocaleBox.boxName).put(LocaleBox.localeKey, code);
    emit(Locale(code));
    await syncLanguageWithBackend();
  }

  /// Syncs the current local language preference with the backend if the user is authenticated.
  Future<void> syncLanguageWithBackend() async {
    try {
      final tokenManager = sl<TokenManager>();
      final token = await tokenManager.getAccessToken();
      if (token != null) {
        final datasource = sl<ProfileRemoteDatasource>();
        await datasource.updateLanguage(languageCode: state.languageCode);
        debugPrint('🌐 [LocaleCubit] Successfully synced language "${state.languageCode}" with backend.');
      }
    } catch (e) {
      debugPrint('⚠️ [LocaleCubit] Failed to sync language with backend: $e');
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}
