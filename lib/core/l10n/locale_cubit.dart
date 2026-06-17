import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_language_usecase.dart';
import 'locale_box.dart';

class LocaleCubit extends Cubit<Locale> {
  final TokenManager tokenManager;
  final GetProfileUseCase getProfileUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;

  LocaleCubit({
    required this.tokenManager,
    required this.getProfileUseCase,
    required this.updateLanguageUseCase,
  }) : super(Locale(_initialLanguageCode()));

  /// Called at startup — applies the local language first, then refreshes it
  /// from the authenticated profile when available.
  Future<void> init() async {
    final box = Hive.box(LocaleBox.boxName);
    final localLanguage = _localLanguageCode(box);
    await box.put(LocaleBox.localeKey, localLanguage);

    if (state.languageCode != localLanguage) {
      emit(Locale(localLanguage));
    }

    await applyPreferredLanguageFromProfile();
  }

  Future<void> setLocale(String code) async {
    await Hive.box(LocaleBox.boxName).put(LocaleBox.localeKey, code);
    emit(Locale(code));
    await syncLanguageWithBackend();
  }

  /// Reads the authenticated user's preferred language from `/Users/me`.
  ///
  /// Returns true when a valid backend preference was applied. If the user is
  /// not authenticated or the profile request fails, callers should fall back
  /// to local/device language without overwriting the backend preference.
  Future<bool> applyPreferredLanguageFromProfile() async {
    try {
      final token = await tokenManager.getAccessToken();
      if (token == null) return false;

      final result = await getProfileUseCase(NoParams());
      return result.fold<Future<bool>>(
        (_) async => false,
        (profile) async {
          final language = _normalizeLanguage(profile.preferredLanguage);
          if (language == null) return false;
          await Hive.box(LocaleBox.boxName).put(LocaleBox.localeKey, language);
          emit(Locale(language));
          debugPrint('Applied profile preferred language "$language".');
          return true;
        },
      );
    } catch (e) {
      debugPrint('Failed to apply profile preferred language: $e');
      return false;
    }
  }

  /// Syncs the current local language preference with the backend if the user is authenticated.
  Future<void> syncLanguageWithBackend() async {
    try {
      final token = await tokenManager.getAccessToken();
      if (token != null) {
        await updateLanguageUseCase(languageCode: state.languageCode);
        debugPrint('Synced language "${state.languageCode}" with backend.');
      }
    } catch (e) {
      debugPrint('Failed to sync language with backend: $e');
    }
  }

  bool get isArabic => state.languageCode == 'ar';

  String? _normalizeLanguage(String? language) {
    return _normalizeLanguageCode(language);
  }

  static String _initialLanguageCode() {
    try {
      if (Hive.isBoxOpen(LocaleBox.boxName)) {
        return _localLanguageCode(Hive.box(LocaleBox.boxName));
      }
    } catch (_) {
      // Fall through to device/default language.
    }
    return _deviceLanguageCode();
  }

  static String _localLanguageCode(Box<dynamic> box) {
    final saved = _normalizeLanguageCode(box.get(LocaleBox.localeKey) as String?);
    return saved ?? _deviceLanguageCode();
  }

  static String _deviceLanguageCode() {
    final deviceLang =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return deviceLang == 'ar' ? 'ar' : 'en';
  }

  static String? _normalizeLanguageCode(String? language) {
    final clean = language?.trim().toLowerCase();
    if (clean == null || clean.isEmpty) return null;
    return clean == 'ar' ? 'ar' : 'en';
  }
}
