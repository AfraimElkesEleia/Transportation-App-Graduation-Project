import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartEntity? _latestCart;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  void _onCheckout(int pointsToRedeem) {
    context.read<CartCubit>().checkout(pointsToRedeem: pointsToRedeem);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BasicContainer(
        child: SafeArea(
          child: Column(
            children: [
              _CartAppBar(title: l10n.myCart),
              Expanded(
                child: BlocConsumer<CartCubit, CartState>(
                    listener: (context, state) {
                      if (state is CartLoaded) {
                        _latestCart = state.cart;
                      } else if (state is CheckoutSuccess) {
                        _showCheckoutSuccessDialog(context, l10n);
                      } else if (state is CheckoutError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ErrorLocalizer.localize(context, state.message),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        context.read<CartCubit>().fetchCart();
                      } else if (state is CartItemCancelError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ErrorLocalizer.localize(context, state.message),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CartLoading && _latestCart == null) {
                        return _buildLoadingCart();
                      }
                      if (state is CartEmpty) {
                        return _buildEmptyCart(l10n);
                      }
                      if (state is CartError) {
                        return _buildError(
                          ErrorLocalizer.localize(context, state.message),
                          l10n,
                        );
                      }
                      if (state is CartLoaded) {
                        return _buildCartList(
                          state.cart,
                          isCheckingOut: false,
                        );
                      }
                      if (state is CheckoutLoading && _latestCart != null) {
                        return _buildCartList(
                          _latestCart!,
                          isCheckingOut: true,
                        );
                      }
                      if (state is CartItemCancelling && _latestCart != null) {
                        return _buildCartList(
                          _latestCart!,
                          isCheckingOut: false,
                        );
                      }
                      return _latestCart == null
                          ? const SizedBox.shrink()
                          : _buildCartList(_latestCart!, isCheckingOut: false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildLoadingCart() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 3,
      itemBuilder: (_, __) => const AppShimmerCard(),
    );
  }

  Widget _buildEmptyCart(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: ColorsManager.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.yourCartIsEmpty,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.addTripsToCart,
              style: const TextStyle(
                color: ColorsManager.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<CartCubit>().fetchCart(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(CartEntity cart, {required bool isCheckingOut}) {
    return _CheckoutPanel(
      items: cart.items,
      grandTotal: cart.grandTotal,
      isCheckingOut: isCheckingOut,
      onCheckout: _onCheckout,
    );
  }

  void _showCheckoutSuccessDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          l10n.checkoutSuccess,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.backToHome),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartAppBar extends StatelessWidget {
  final String title;

  const _CartAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorsManager.surfaceMid,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorsManager.borderSubtle),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: ColorsManager.accentCyan,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsManager.borderSubtle),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _CheckoutPanel extends StatefulWidget {
  final List<CartItemEntity> items;
  final double grandTotal;
  final bool isCheckingOut;
  final void Function(int points) onCheckout;

  const _CheckoutPanel({
    required this.items,
    required this.grandTotal,
    required this.isCheckingOut,
    required this.onCheckout,
  });

  @override
  State<_CheckoutPanel> createState() => _CheckoutPanelState();
}

class _CheckoutPanelState extends State<_CheckoutPanel> {
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
  void didUpdateWidget(covariant _CheckoutPanel oldWidget) {
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
            return _PaymentSummarySheet(
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
                  child: _LoyaltyPointsCard(
                    enabled: _pointsEnabled,
                    canRedeem: _canRedeem,
                    balance: _loyaltyBalance,
                    selectedPoints: _selectedPoints,
                    discount: _discountEgp,
                    remainingPoints: _remainingPoints,
                    sliderMax: _sliderMax,
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
                child: _StickyCheckoutBar(
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

class _LoyaltyPointsCard extends StatelessWidget {
  final bool enabled;
  final bool canRedeem;
  final int balance;
  final int selectedPoints;
  final double discount;
  final int remainingPoints;
  final int sliderMax;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onPointsChanged;

  const _LoyaltyPointsCard({
    required this.enabled,
    required this.canRedeem,
    required this.balance,
    required this.selectedPoints,
    required this.discount,
    required this.remainingPoints,
    required this.sliderMax,
    required this.onEnabledChanged,
    required this.onPointsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
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
          if (enabled) ...[
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 16,
                ),
              ),
              child: Slider(
                min: 0,
                max: sliderMax.toDouble(),
                divisions: sliderMax ~/ _CheckoutPanelState._sliderStep,
                value: selectedPoints.toDouble(),
                label: l10n.ptsValue(selectedPoints.toString()),
                activeColor: ColorsManager.accentCyan,
                inactiveColor: Colors.white24,
                onChanged: (value) {
                  final points =
                      ((value / _CheckoutPanelState._sliderStep).round() *
                              _CheckoutPanelState._sliderStep)
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
        ],
      ),
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
          _SummaryRow(
            label: l10n.pointsUsed,
            value: l10n.ptsValue(selectedPoints.toString()),
          ),
          const SizedBox(height: 5),
          _SummaryRow(
            label: l10n.discount,
            value: '-${discount.toStringAsFixed(2)} ${l10n.egp}',
            valueColor: ColorsManager.successGreen,
          ),
          const SizedBox(height: 5),
          _SummaryRow(
            label: l10n.remainingAfter,
            value: l10n.ptsValue(remainingPoints.toString()),
            valueColor: ColorsManager.accentCyan,
          ),
        ],
      ),
    );
  }
}

class _StickyCheckoutBar extends StatelessWidget {
  final String totalLabel;
  final double total;
  final bool isLoading;
  final VoidCallback onTotalTap;
  final VoidCallback onCheckoutTap;

  const _StickyCheckoutBar({
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

class _PaymentSummarySheet extends StatelessWidget {
  final ScrollController scrollController;
  final double cartTotal;
  final double discount;
  final double payableTotal;
  final bool isCheckingOut;
  final VoidCallback onCheckout;

  const _PaymentSummarySheet({
    required this.scrollController,
    required this.cartTotal,
    required this.discount,
    required this.payableTotal,
    required this.isCheckingOut,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.reviewCheckout,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsManager.cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ColorsManager.borderSubtle),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: l10n.ticketPrice,
                    value: '${cartTotal.toStringAsFixed(2)} ${l10n.egp}',
                  ),
                  const SizedBox(height: 12),
                  _SummaryRow(
                    label: l10n.pointsDiscount,
                    value: '-${discount.toStringAsFixed(2)} ${l10n.egp}',
                    valueColor: ColorsManager.successGreen,
                  ),
                  const Divider(color: Colors.white24, height: 28),
                  _SummaryRow(
                    label: l10n.finalTotal,
                    value: '${payableTotal.toStringAsFixed(2)} ${l10n.egp}',
                    valueColor: ColorsManager.accentCyan,
                    isEmphasized: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isCheckingOut ? null : onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.accentCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: isCheckingOut
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        l10n.checkoutAction,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isEmphasized;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
    this.isEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isEmphasized ? Colors.white : Colors.white70,
              fontSize: isEmphasized ? 15 : 13,
              fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: isEmphasized ? 18 : 13,
              fontWeight: isEmphasized ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
