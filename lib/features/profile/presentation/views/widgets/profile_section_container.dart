import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Reusable section wrapper with an icon + title header.
///
/// Used by [PersonalInfoSection] and [QuickActionsSection] to maintain
/// a consistent card appearance across the profile screen.
class ProfileSectionContainer extends StatelessWidget {
  /// Section title displayed next to the icon.
  final String title;

  /// Leading icon for the section header.
  final IconData icon;

  /// The content widgets rendered below the header.
  final List<Widget> children;

  const ProfileSectionContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.sectionCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.cyan),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
