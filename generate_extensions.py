
import json

with open('egypt_stations_flat_localized.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Build unique maps
en_to_ar_station = {}
ar_to_en_station = {}
en_to_ar_subgov = {}
ar_to_en_subgov = {}

for entry in data:
    en = entry.get('station_en', '').strip()
    ar = entry.get('station_ar', '').strip()
    sub_en = entry.get('sub_governorate_en', '').strip()
    sub_ar = entry.get('sub_governorate_ar', '').strip()

    if en and ar:
        key = en.lower()
        if key not in en_to_ar_station:
            en_to_ar_station[key] = ar
        if ar not in ar_to_en_station:
            ar_to_en_station[ar] = en

    if sub_en and sub_ar:
        key = sub_en.lower()
        if key not in en_to_ar_subgov:
            en_to_ar_subgov[key] = sub_ar
        if sub_ar not in ar_to_en_subgov:
            ar_to_en_subgov[sub_ar] = sub_en

def dart_string(s):
    # Escape single quotes for Dart
    return s.replace("'", "\\'")

lines = []
lines.append("import 'package:flutter/material.dart';")
lines.append("import 'package:flutter_bloc/flutter_bloc.dart';")
lines.append("import 'package:transportation_app/core/l10n/locale_cubit.dart';")
lines.append("import 'package:transportation_app/core/l10n/app_localizations.dart';")
lines.append("")
lines.append("extension Navigation on BuildContext {")
lines.append("  Future<dynamic> pushNamed(String route, {Object? arguments}) {")
lines.append("    return Navigator.of(this).pushNamed(route, arguments: arguments);")
lines.append("  }")
lines.append("")
lines.append("  Future<dynamic> pushReplacementNamed(String route, {Object? arguments}) {")
lines.append("    return Navigator.of(this).pushReplacementNamed(route, arguments: arguments);")
lines.append("  }")
lines.append("")
lines.append("  Future<dynamic> pushNamedAndRemoveuntil(")
lines.append("    String route, {")
lines.append("    Object? arguments,")
lines.append("    required RoutePredicate predicate,")
lines.append("  }) {")
lines.append("    return Navigator.of(")
lines.append("      this,")
lines.append("    ).pushNamedAndRemoveUntil(route, predicate, arguments: arguments);")
lines.append("  }")
lines.append("")
lines.append("  void pop() => Navigator.of(this).pop();")
lines.append("}")
lines.append("")
lines.append("extension LocaleHelper on BuildContext {")
lines.append("  bool get isArabic => watch<LocaleCubit>().isArabic;")
lines.append("}")
lines.append("")

# GovernorateHelper (unchanged)
lines.append("extension GovernorateHelper on String {")
lines.append("  String toLocalizedGov(BuildContext context) {")
lines.append("    if (!context.isArabic) return this;")
lines.append("    final l10n = AppLocalizations.of(context);")
lines.append("    if (l10n == null) return this;")
lines.append("")
lines.append("    const Map<String, String Function(AppLocalizations)> _govMap = {");
# We'll use a different approach - use the existing switch but as a map approach
# Actually let's keep the gov localization through l10n keys as before
lines.pop()
lines.pop()

lines.append("    switch (toLowerCase()) {")
lines.append("      case 'cairo':")
lines.append("        return l10n.gov_Cairo;")
lines.append("      case 'alexandria':")
lines.append("        return l10n.gov_Alexandria;")
lines.append("      case 'giza':")
lines.append("        return l10n.gov_Giza;")
lines.append("      case 'aswan':")
lines.append("        return l10n.gov_Aswan;")
lines.append("      case 'luxor':")
lines.append("        return l10n.gov_Luxor;")
lines.append("      case 'minya':")
lines.append("        return l10n.gov_Minya;")
lines.append("      case 'beheira':")
lines.append("        return l10n.gov_Beheira;")
lines.append("      case 'qena':")
lines.append("        return l10n.gov_Qena;")
lines.append("      case 'sohag':")
lines.append("        return l10n.gov_Sohag;")
lines.append("      case 'asyut':")
lines.append("        return l10n.gov_Asyut;")
lines.append("      case 'fayoum':")
lines.append("        return l10n.gov_Fayoum;")
lines.append("      case 'beni suef':")
lines.append("        return l10n.gov_BeniSuef;")
lines.append("      case 'sharqia':")
lines.append("        return l10n.gov_Sharqia;")
lines.append("      case 'dakahlia':")
lines.append("        return l10n.gov_Dakahlia;")
lines.append("      case 'gharbiya':")
lines.append("        return l10n.gov_Gharbiya;")
lines.append("      case 'kafr el sheikh':")
lines.append("        return l10n.gov_KafrElSheikh;")
lines.append("      case 'monufia':")
lines.append("        return l10n.gov_Monufia;")
lines.append("      case 'qalyubia':")
lines.append("        return l10n.gov_Qalyubia;")
lines.append("      case 'ismailia':")
lines.append("        return l10n.gov_Ismailia;")
lines.append("      case 'suez':")
lines.append("        return l10n.gov_Suez;")
lines.append("      case 'damietta':")
lines.append("        return l10n.gov_Damietta;")
lines.append("      default:")
lines.append("        return this;")
lines.append("    }")
lines.append("  }")
lines.append("}")
lines.append("")

# SubGovernorate Helper using a map
lines.append("// Map from English sub-governorate name (lowercase) to Arabic")
lines.append("const Map<String, String> _subGovEnToAr = {")
for key, val in sorted(en_to_ar_subgov.items()):
    lines.append(f"  '{dart_string(key)}': '{dart_string(val)}',")
lines.append("};")
lines.append("")
lines.append("// Map from Arabic sub-governorate name to English")
lines.append("const Map<String, String> _subGovArToEn = {")
for key, val in sorted(ar_to_en_subgov.items()):
    lines.append(f"  '{dart_string(key)}': '{dart_string(val)}',")
lines.append("};")
lines.append("")
lines.append("extension SubGovernorateHelper on String {")
lines.append("  String toLocalizedSubGov(BuildContext context) {")
lines.append("    if (context.isArabic) {")
lines.append("      return _subGovEnToAr[toLowerCase()] ?? this;")
lines.append("    } else {")
lines.append("      return _subGovArToEn[this] ?? this;")
lines.append("    }")
lines.append("  }")
lines.append("}")
lines.append("")

# Station Helper using a map
lines.append("// Map from English station name (lowercase) to Arabic")
lines.append("const Map<String, String> _stationEnToAr = {")
for key, val in sorted(en_to_ar_station.items()):
    lines.append(f"  '{dart_string(key)}': '{dart_string(val)}',")
lines.append("};")
lines.append("")
lines.append("// Map from Arabic station name to English")
lines.append("const Map<String, String> _stationArToEn = {")
for key, val in sorted(ar_to_en_station.items()):
    lines.append(f"  '{dart_string(key)}': '{dart_string(val)}',")
lines.append("};")
lines.append("")
lines.append("extension StationHelper on String {")
lines.append("  String toLocalizedStation(BuildContext context) {")
lines.append("    if (context.isArabic) {")
lines.append("      return _stationEnToAr[toLowerCase()] ?? this;")
lines.append("    } else {")
lines.append("      return _stationArToEn[this] ?? this;")
lines.append("    }")
lines.append("  }")
lines.append("}")
lines.append("")

output = '\n'.join(lines)
with open('lib/core/helper/extensions.dart', 'w', encoding='utf-8') as f:
    f.write(output)

print(f"Generated extensions.dart with {len(en_to_ar_station)} stations and {len(en_to_ar_subgov)} sub-governorates")
