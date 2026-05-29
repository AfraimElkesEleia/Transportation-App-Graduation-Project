import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';

/// Bottom bar showing selected seats summary, total price, and Continue button.
class SeatBottomBar extends StatelessWidget {
  final Set<String> selectedSeats;
  final double pricePerSeat;
  final double total;
  final VoidCallback onProceed;

  const SeatBottomBar({
    super.key,
    required this.selectedSeats,
    required this.pricePerSeat,
    required this.total,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = selectedSeats.join(', ');
    final hasSelection = selectedSeats.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: Color(0xFF1E3A52), height: 1),

        // ── Summary row ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: seat count + labels
              _SelectedSeatsInfo(
                l10n: l10n,
                count: selectedSeats.length,
                labels: labels,
              ),
              // Right: total price
              _TotalPriceInfo(l10n: l10n, total: total),
            ],
          ),
        ),

        // ── Continue button ──
        _ContinueButton(
          label: l10n.continueBtn,
          enabled: hasSelection,
          onPressed: onProceed,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _SelectedSeatsInfo
// ─────────────────────────────────────────────────────────────────
class _SelectedSeatsInfo extends StatelessWidget {
  final AppLocalizations l10n;
  final int count;
  final String labels;

  const _SelectedSeatsInfo({
    required this.l10n,
    required this.count,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: l10n.selectedSeatsLabel,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            children: [
              TextSpan(
                text: l10n.seatsCount('$count'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          labels.isEmpty ? l10n.noSeatsSelected : labels,
          style: const TextStyle(
            color: ColorsManager.accentCyan,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _TotalPriceInfo
// ─────────────────────────────────────────────────────────────────
class _TotalPriceInfo extends StatelessWidget {
  final AppLocalizations l10n;
  final double total;

  const _TotalPriceInfo({required this.l10n, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l10n.totalLabel,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        Text(
          '${l10n.egp} ${total.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _ContinueButton — gradient when active, muted when disabled
// ─────────────────────────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: enabled
                  ? const LinearGradient(
                      colors: [
                        ColorsManager.seatSelected,
                        ColorsManager.accentCyan,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : const LinearGradient(
                      colors: [
                        ColorsManager.seatContainerBg,
                        ColorsManager.seatContainerBg,
                      ],
                    ),
              borderRadius: BorderRadius.circular(27),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: enabled ? ColorsManager.seatBg : Colors.white38,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
