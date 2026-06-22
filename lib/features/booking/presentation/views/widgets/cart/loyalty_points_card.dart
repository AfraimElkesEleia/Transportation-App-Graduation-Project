import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/checkout_summary_row.dart';

class LoyaltyPointsCard extends StatelessWidget {
  final bool enabled;
  final bool canRedeem;
  final int balance;
  final int selectedPoints;
  final double discount;
  final int remainingPoints;
  final int sliderMax;
  final int sliderStep;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onPointsChanged;

  const LoyaltyPointsCard({
    super.key,
    required this.enabled,
    required this.canRedeem,
    required this.balance,
    required this.selectedPoints,
    required this.discount,
    required this.remainingPoints,
    required this.sliderMax,
    required this.sliderStep,
    required this.onEnabledChanged,
    required this.onPointsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: enabled
              ? ColorsManager.accentCyan.withAlpha(115)
              : ColorsManager.borderSubtle,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: ColorsManager.accentCyan.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.diamond_outlined,
                  color: ColorsManager.accentCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.useLoyaltyPointsTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.youHavePoints(balance.toString()),
                      style: const TextStyle(
                        color: ColorsManager.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: enabled,
                activeThumbColor: ColorsManager.accentCyan,
                activeTrackColor: ColorsManager.accentCyan.withAlpha(70),
                onChanged: canRedeem ? onEnabledChanged : null,
              ),
            ],
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: enabled
                    ? _ExpandedLoyaltyContent(
                        key: const ValueKey('loyalty-expanded'),
                        selectedPoints: selectedPoints,
                        discount: discount,
                        remainingPoints: remainingPoints,
                        sliderMax: sliderMax,
                        sliderStep: sliderStep,
                        onPointsChanged: onPointsChanged,
                      )
                    : const SizedBox(
                        key: ValueKey('loyalty-collapsed'),
                        width: double.infinity,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedLoyaltyContent extends StatelessWidget {
  final int selectedPoints;
  final double discount;
  final int remainingPoints;
  final int sliderMax;
  final int sliderStep;
  final ValueChanged<int> onPointsChanged;

  const _ExpandedLoyaltyContent({
    super.key,
    required this.selectedPoints,
    required this.discount,
    required this.remainingPoints,
    required this.sliderMax,
    required this.sliderStep,
    required this.onPointsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            min: 0,
            max: sliderMax.toDouble(),
            divisions: sliderMax ~/ sliderStep,
            value: selectedPoints.toDouble(),
            label: l10n.ptsValue(selectedPoints.toString()),
            activeColor: ColorsManager.accentCyan,
            inactiveColor: Colors.white24,
            onChanged: (value) {
              final points = ((value / sliderStep).round() * sliderStep)
                  .toInt();
              onPointsChanged(points);
            },
          ),
        ),
        _CompactPointsReceipt(
          selectedPoints: selectedPoints,
          discount: discount,
          remainingPoints: remainingPoints,
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.pointsConversionHint,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _CompactPointsReceipt extends StatelessWidget {
  final int selectedPoints;
  final double discount;
  final int remainingPoints;

  const _CompactPointsReceipt({
    required this.selectedPoints,
    required this.discount,
    required this.remainingPoints,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CheckoutSummaryRow(
            label: l10n.pointsUsed,
            value: l10n.ptsValue(selectedPoints.toString()),
          ),
          const SizedBox(height: 5),
          CheckoutSummaryRow(
            label: l10n.discount,
            value: '-${discount.toStringAsFixed(2)} ${l10n.egp}',
            valueColor: ColorsManager.successGreen,
          ),
          const SizedBox(height: 5),
          CheckoutSummaryRow(
            label: l10n.remainingAfter,
            value: l10n.ptsValue(remainingPoints.toString()),
            valueColor: ColorsManager.accentCyan,
          ),
        ],
      ),
    );
  }
}
