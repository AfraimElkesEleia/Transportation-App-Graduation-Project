import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/locale_cubit.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String route, {Object? arguments}) {
    return Navigator.of(this).pushNamed(route, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String route, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(route, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveuntil(
    String route, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(route, predicate, arguments: arguments);
  }
  void pop() => Navigator.of(this).pop();
}

extension LocaleHelper on BuildContext {
  bool get isArabic => watch<LocaleCubit>().isArabic;
}

extension GovernorateHelper on String {
  String toLocalizedGov(BuildContext context) {
    if (!context.isArabic) return this;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return this;
    
    switch (toLowerCase()) {
      case 'cairo': return l10n.gov_Cairo;
      case 'alexandria': return l10n.gov_Alexandria;
      case 'giza': return l10n.gov_Giza;
      case 'aswan': return l10n.gov_Aswan;
      case 'luxor': return l10n.gov_Luxor;
      case 'minya': return l10n.gov_Minya;
      case 'beheira': return l10n.gov_Beheira;
      case 'qena': return l10n.gov_Qena;
      case 'sohag': return l10n.gov_Sohag;
      case 'asyut': return l10n.gov_Asyut;
      case 'fayoum': return l10n.gov_Fayoum;
      case 'beni suef': return l10n.gov_BeniSuef;
      case 'sharqia': return l10n.gov_Sharqia;
      case 'dakahlia': return l10n.gov_Dakahlia;
      case 'gharbiya': return l10n.gov_Gharbiya;
      case 'kafr el sheikh': return l10n.gov_KafrElSheikh;
      case 'monufia': return l10n.gov_Monufia;
      case 'qalyubia': return l10n.gov_Qalyubia;
      case 'ismailia': return l10n.gov_Ismailia;
      case 'suez': return l10n.gov_Suez;
      case 'damietta': return l10n.gov_Damietta;
      default: return this;
    }
  }
}

extension StationHelper on String {
  String toLocalizedStation(BuildContext context) {
    // If it's Arabic mode and the string is Arabic, keep it. 
    // If it's English mode and the string is Arabic, translate to English.
    // We do a simple map for known stations since backend might send Arabic names in English fields.
    if (context.isArabic) return this;
    
    switch (this) {
      case 'نادي السكة': return 'Nadi El Seka';
      case 'سوهاج': return 'Sohag';
      case 'عبد القادر': return 'Abd El Qader';
      case 'سماد ابو قير': return 'Abo Qir Fertilizer';
      case 'الاسكندرية': return 'Alexandria';
      case 'بهيج': return 'Baheeg';
      case 'برج العرب': return 'Borg El Arab';
      // Add more station translations here as needed
      default: return this;
    }
  }
}
