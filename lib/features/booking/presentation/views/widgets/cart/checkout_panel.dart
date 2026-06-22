import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/loyalty_points_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/payment_summary_sheet.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/sticky_checkout_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart_item_card.dart';

class CheckoutPanel extends StatefulWidget {
  final List<CartItemEntity> items;
  final double grandTotal;
  final bool isCheckingOut;
  final void Function(int points) onCheckout;

  const CheckoutPanel({
    super.key,
    required this.items,
    required this.grandTotal,
    required this.isCheckingOut,
    required this.onCheckout,
  });

  @override
  State<CheckoutPanel> createState() => _CheckoutPanelState();
}

class _CheckoutPanelState extends State<CheckoutPanel> {
  static const double _pointValueEgp = 0.05;
  static const double _maxDiscountPct = 0.50;
  static const double _minFinalPrice = 10.00;
  static const int _sliderStep = 20;

  int _selectedPoints = 0;
  int _loyaltyBalance = 0;
  bool _pointsEnabled = false;

  int get _sliderMax {
    if (widget.grandTotal <= _minFinalPrice || _loyaltyBalance <= 0) return 0;
    final halfCapLimit = ((widget.grandTotal * _maxDiscountPct) / _pointValueEgp)
        .floor();
    final floorLimit = ((widget.grandTotal - _minFinalPrice) / _pointValueEgp)
        .floor();
    final raw = min(_loyaltyBalance, min(halfCapLimit, floorLimit));
    return (raw ~/ _sliderStep) * _sliderStep;
  }

  double get _discountEgp => _selectedPoints * _pointValueEgp;
  double get _payableTotal => widget.grandTotal - _discountEgp;
  int get _remainingPoints => _loyaltyBalance - _selectedPoints;
  bool get _canRedeem => _sliderMax >= _sliderStep;

  @override
  void initState() {
    super.initState();
    _loadCachedLoyaltyBalance();
  }

  @override
  void didUpdateWidget(covariant CheckoutPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grandTotal != widget.grandTotal) {
      _resetPoints();
    }
  }

  Future<void> _loadCachedLoyaltyBalance() async {
    final user = await sl<TokenManager>().getUser();
    if (!mounted) return;
    setState(() {
      _loyaltyBalance = user?.loyaltyPointsBalance ?? 0;
    });
  }

  void _resetPoints() {
    setState(() {
      _selectedPoints = 0;
      _pointsEnabled = false;
    });
  }

  void _setPointsEnabled(bool value) {
    setState(() {
      _pointsEnabled = value && _canRedeem;
      if (!_pointsEnabled) _selectedPoints = 0;
    });
  }

  void _openPaymentSummary() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.36,
          minChildSize: 0.30,
          maxChildSize: 0.58,
          expand: false,
          builder: (context, scrollController) {
            return PaymentSummarySheet(
              scrollController: scrollController,
              cartTotal: widget.grandTotal,
              discount: _discountEgp,
              payableTotal: _payableTotal,
              isCheckingOut: widget.isCheckingOut,
              onCheckout: () {
                Navigator.of(sheetContext).pop();
                widget.onCheckout(_selectedPoints);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              itemCount: widget.items.length + 1,
              itemBuilder: (context, index) {
                if (index < widget.items.length) {
                  return CartItemCard(item: widget.items[index]);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: LoyaltyPointsCard(
                    enabled: _pointsEnabled,
                    canRedeem: _canRedeem,
                    balance: _loyaltyBalance,
                    selectedPoints: _selectedPoints,
                    discount: _discountEgp,
                    remainingPoints: _remainingPoints,
                    sliderMax: _sliderMax,
                    sliderStep: _sliderStep,
                    onEnabledChanged: _setPointsEnabled,
                    onPointsChanged: (points) {
                      setState(() => _selectedPoints = points);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: ColorsManager.surfaceDarker,
              border: Border(top: BorderSide(color: ColorsManager.borderDim)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: StickyCheckoutBar(
                  totalLabel: l10n.finalTotal,
                  total: _payableTotal,
                  isLoading: widget.isCheckingOut,
                  onTotalTap: _openPaymentSummary,
                  onCheckoutTap: _openPaymentSummary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
