import 'package:flutter/material.dart';

class PageViewModel {
  final String subtitle;
  final String title;
  final String description;
  final IconData icon;

  const PageViewModel({
    required this.subtitle,
    required this.title,
    required this.description,
    required this.icon,
  });
}
