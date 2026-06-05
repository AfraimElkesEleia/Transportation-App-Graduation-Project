import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/token_manager.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart_item_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/points_redemption_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
              // ── App Bar ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ColorsManager.buttonBlue,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ColorsManager.borderSubtle),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        l10n.myCart,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: ColorsManager.accentCyan,
                      size: 22,
                    ),
                  ],
                ),
              ),

              // ── Body ───────────────────────────────────────────────────
              Expanded(
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is CheckoutSuccess) {
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
                    }
                  },
                  builder: (context, state) {
                    if (state is CartLoading || state is CheckoutLoading) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: 3,
                        itemBuilder: (_, __) => const AppShimmerCard(),
                      );
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
                      return _buildCartList(state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
          Text(
            l10n.addTripsToCart,
            style: const TextStyle(
              color: ColorsManager.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, AppLocalizations l10n) {
    return Center(
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
              backgroundColor: ColorsManager.surfaceMid,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              return CartItemCard(item: state.cart.items[index]);
            },
          ),
        ),
        _CartBottomBar(
          grandTotal: state.cart.grandTotal,
          onCheckout: _onCheckout,
        ),
      ],
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
                Navigator.of(ctx).pop(); // close dialog
                // Pop back to the very first route (home screen).
                // Using route.isFirst instead of matching by name because
                // the initialRoute is not always assigned a named settings entry.
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
              ),
              child: Text(
                l10n.backToHome,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// _CartBottomBar — loyalty points + checkout button
// ─────────────────────────────────────────────────────────────────
class _CartBottomBar extends StatefulWidget {
  final double grandTotal;
  final void Function(int points) onCheckout;

  const _CartBottomBar({required this.grandTotal, required this.onCheckout});

  @override
  State<_CartBottomBar> createState() => _CartBottomBarState();
}

class _CartBottomBarState extends State<_CartBottomBar> {
  int _selectedPoints = 0;
  int _loyaltyBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadCachedLoyaltyBalance();
  }

  Future<void> _loadCachedLoyaltyBalance() async {
    final user = await sl<TokenManager>().getUser();
    if (!mounted) return;
    setState(() {
      _loyaltyBalance = user?.loyaltyPointsBalance ?? 0;
    });
  }

  void _handleCheckout(BuildContext context) {
    widget.onCheckout(_selectedPoints);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: ColorsManager.surfaceDark,
        border: Border(
          top: BorderSide(color: ColorsManager.borderDim, width: 1),
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PointsRedemptionWidget(
            cartTotal: widget.grandTotal,
            walletPoints: _loyaltyBalance,
            onPointsChanged: (pts) => setState(() => _selectedPoints = pts),
          ),
          const SizedBox(height: 16),
          // ── Checkout button ─────────────────────────────────────────
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final isLoading = state is CheckoutLoading;
              return SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _handleCheckout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.accentCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.checkoutWallet,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
