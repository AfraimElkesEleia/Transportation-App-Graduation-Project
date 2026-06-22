import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/locale_cubit.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// A compact EN/AR toggle button that plugs into LocaleCubit.
/// Drop it anywhere — onboarding, login, signup.
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isAr = locale.languageCode == 'ar';
        return GestureDetector(
          onTap: () => context
              .read<LocaleCubit>()
              .setLocale(isAr ? 'en' : 'ar'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorsManager.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorsManager.accentCyan.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAr ? 'EN' : 'ع',
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.language_rounded,
                  color: ColorsManager.accentCyan,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
