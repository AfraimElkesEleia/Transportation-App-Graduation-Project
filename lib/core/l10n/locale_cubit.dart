import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'locale_box.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  /// Called at startup — reads Hive, falls back to device locale
  Future<void> init() async {
    final box = Hive.box(LocaleBox.boxName);
    final saved = box.get(LocaleBox.localeKey) as String?;
    if (saved != null) {
      emit(Locale(saved));
      return;
    }
    // First launch → detect device locale
    final deviceLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final lang = deviceLang == 'ar' ? 'ar' : 'en';
    await box.put(LocaleBox.localeKey, lang);
    emit(Locale(lang));
  }

  Future<void> setLocale(String code) async {
    await Hive.box(LocaleBox.boxName).put(LocaleBox.localeKey, code);
    emit(Locale(code));
  }

  bool get isArabic => state.languageCode == 'ar';
}
