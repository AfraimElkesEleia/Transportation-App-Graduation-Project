import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';

class TripTypeToggle extends StatelessWidget {
  final bool isRoundTrip;
  final ValueChanged<bool> onChanged;

  const TripTypeToggle({
    super.key,
    required this.isRoundTrip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1F30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3A52)),
      ),
      child: Row(
        children: [
          _tripTypeOption(
            label: l10n.oneWay,
            icon: Icons.arrow_forward_rounded,
            selected: !isRoundTrip,
            onTap: () => onChanged(false),
          ),
          _tripTypeOption(
            label: l10n.roundTripToggle,
            icon: Icons.swap_horiz_rounded,
            selected: isRoundTrip,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _tripTypeOption({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? ColorsManager.cyanBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? Colors.white : Colors.white38),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? Colors.white : Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
