import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_app/features/signup/presentation/widgets/gender.dart';

/// A labelled, two-chip gender selector matching the app's dark theme.
///
/// Usage:
/// ```dart
/// AppGenderSelector(
///   selected: _gender,
///   onChanged: (g) => setState(() => _gender = g),
///   errorText: _genderError,
/// )
/// ```
class AppGenderSelector extends StatelessWidget {
  const AppGenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.errorText,
  });

  final Gender? selected;
  final ValueChanged<Gender> onChanged;
  final String? errorText;

  static const _cyan   = Color(0xff1AC8E8);
  static const _white20 = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ─────────────────────────────
        Text(
          'Gender',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 4,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 10),

        // ── Chips ─────────────────────────────
        Row(
          children: Gender.values
              .map((g) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: g == Gender.male ? 10 : 0,
                      ),
                      child: _GenderChip(
                        gender: g,
                        isSelected: selected == g,
                        onTap: () => onChanged(g),
                      ),
                    ),
                  ))
              .toList(),
        ),

        // ── Validation error ──────────────────
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  static const _cyan    = Color(0xff1AC8E8);
  static const _blue    = Color(0xff1E5EFF);
  static const _white20 = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [_blue, _cyan])
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : _white20,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _cyan.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gender.icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w300,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}