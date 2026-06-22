import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';

class StickyCheckoutBar extends StatelessWidget {
  final String totalLabel;
  final double total;
  final bool isLoading;
  final VoidCallback onTotalTap;
  final VoidCallback onCheckoutTap;

  const StickyCheckoutBar({
    super.key,
    required this.totalLabel,
    required this.total,
    required this.isLoading,
    required this.onTotalTap,
    required this.onCheckoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ColorsManager.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTotalTap,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalLabel,
                      style: const TextStyle(
                        color: ColorsManager.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${total.toStringAsFixed(2)} ${l10n.egp}',
                        style: const TextStyle(
                          color: ColorsManager.accentCyan,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 146,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : onCheckoutTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.black,
                disabledBackgroundColor: ColorsManager.accentCyan.withAlpha(80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      l10n.checkoutAction,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
