import 'package:flutter/material.dart';

enum Gender {
  male(0),
  female(1);

  const Gender(this.value);
  final int value;

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