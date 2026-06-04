import 'dart:math';
import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class PointsRedemptionWidget extends StatefulWidget {
  final double cartTotal;
  final int walletPoints;
  final ValueChanged<int> onPointsChanged;

  const PointsRedemptionWidget({
    super.key,
    required this.cartTotal,
    required this.walletPoints,
    required this.onPointsChanged,
  });

  @override
  State<PointsRedemptionWidget> createState() => _PointsRedemptionWidgetState();
}

class _PointsRedemptionWidgetState extends State<PointsRedemptionWidget> {
  static const double kPointValue = 0.05; // 1 pt = 0.05 EGP
  static const double kMaxDiscPct = 0.50; // 50% cap
  static const double kMinFinalPrice = 10.00; // 10 EGP floor
  static const int kSliderStep = 20; // whole-EGP steps

  int _selectedPoints = 0;

  int get _sliderMax {
    final walletLimit = widget.walletPoints;
    final halfCapLimit = ((widget.cartTotal * kMaxDiscPct) / kPointValue)
        .floor();
    final floorLimit = ((widget.cartTotal - kMinFinalPrice) / kPointValue)
        .floor();
    final raw = [walletLimit, halfCapLimit, floorLimit].reduce(min);
    return (raw ~/ kSliderStep) * kSliderStep;
  }

  double get _discountEgp => _selectedPoints * kPointValue;
  double get _finalTotal => widget.cartTotal - _discountEgp;
  int get _remainingAfter => widget.walletPoints - _selectedPoints;

  @override
  void didUpdateWidget(covariant PointsRedemptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cartTotal != widget.cartTotal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedPoints = 0);
          widget.onPointsChanged(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Case B — 0 points at all
    if (widget.walletPoints == 0) {
      return _PointsInfoBanner(
        icon: Icons.info_outline,
        color: ColorsManager.accentCyan,
        message: AppLocalizations.of(context)!.noPointsYet,
      );
    }
    // Case C — cart at/below floor
    if (widget.cartTotal <= kMinFinalPrice) {
      return _PointsInfoBanner(
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
        message: AppLocalizations.of(context)!.pointsCantBeApplied,
      );
    }
    // Case D — balance too small for even 1 EGP discount (< 20 pts usable)
    if (_sliderMax < kSliderStep) {
      return _PointsInfoBanner(
        icon: Icons.info_outline,
        color: ColorsManager.accentCyan,
        message: AppLocalizations.of(context)!.needMorePoints('${widget.walletPoints}'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.useLoyaltyPoints,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Slider(
          min: 0,
          max: _sliderMax.toDouble(),
          value: _selectedPoints.toDouble(),
          divisions: _sliderMax ~/ kSliderStep > 0
              ? _sliderMax ~/ kSliderStep
              : 1,
          label: AppLocalizations.of(context)!.ptsValue('$_selectedPoints'),
          activeColor: ColorsManager.accentCyan,
          inactiveColor: Colors.white24,
          onChanged: (v) {
            setState(() {
              _selectedPoints = ((v / kSliderStep).round() * kSliderStep)
                  .toInt();
              widget.onPointsChanged(_selectedPoints);
            });
          },
        ),
        _LiveReceiptCard(
          selectedPoints: _selectedPoints,
          discountEgp: _discountEgp,
          remainingAfter: _remainingAfter,
          finalTotal: _finalTotal,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.pointsInfo,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}

class _LiveReceiptCard extends StatelessWidget {
  final int selectedPoints;
  final double discountEgp;
  final int remainingAfter;
  final double finalTotal;

  const _LiveReceiptCard({
    required this.selectedPoints,
    required this.discountEgp,
    required this.remainingAfter,
    required this.finalTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Column(
        children: [
          _buildRow(AppLocalizations.of(context)!.pointsUsed, AppLocalizations.of(context)!.ptsValue('$selectedPoints'), Colors.white),
          const SizedBox(height: 4),
          _buildRow(
            AppLocalizations.of(context)!.discount,
            '− ${discountEgp.toStringAsFixed(2)} ${AppLocalizations.of(context)!.egp}',
            ColorsManager.successGreen,
          ),
          const SizedBox(height: 4),
          _buildRow(
            AppLocalizations.of(context)!.remainingAfter,
            AppLocalizations.of(context)!.ptsValue('$remainingAfter'),
            ColorsManager.accentCyan,
          ),
          const Divider(color: Colors.white24, height: 16),
          _buildRow(
            AppLocalizations.of(context)!.finalTotal,
            '${finalTotal.toStringAsFixed(2)} ${AppLocalizations.of(context)!.egp}',
            Colors.white,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _PointsInfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _PointsInfoBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
