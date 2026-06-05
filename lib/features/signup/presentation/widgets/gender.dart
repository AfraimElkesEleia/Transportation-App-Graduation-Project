import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

enum Gender {
  male(0),
  female(1);

  const Gender(this.value);
  final int value;

  String getLocalizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case Gender.male:
        return l10n.genderMale;
      case Gender.female:
        return l10n.genderFemale;
    }
  }

  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }

  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
    }
  }
}