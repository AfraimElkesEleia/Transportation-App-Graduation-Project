import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart_item_card.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

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
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.seatContainerBg,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            _showCheckoutSuccessDialog(context);
          } else if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            context.read<CartCubit>().fetchCart();
          }
        },
        builder: (context, state) {
          if (state is CartLoading || state is CheckoutLoading) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: 3,
              itemBuilder: (_, __) => const AppShimmerCard(),
            );
          }
          if (state is CartEmpty) {
            return _buildEmptyCart();
          }
          if (state is CartError) {
            return _buildError(state.message);
          }

          if (state is CartLoaded) {
            return _buildCartList(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: ColorsManager.textMuted,
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add trips to your cart to checkout later.',
            style: TextStyle(color: ColorsManager.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
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
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.seatContainerBg,
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

  void _showCheckoutSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          'Checkout successful!\nYour wallet has been deducted.',
          style: TextStyle(color: Colors.white, fontSize: 16),
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
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
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
  bool _usePoints = false;
  final _pointsCtrl = TextEditingController();

  @override
  void dispose() {
    _pointsCtrl.dispose();
    super.dispose();
  }

  /// Returns the user's loyalty points balance.
  /// ProfileCubit is always provided in scope by the router.
  int _getLoyaltyBalance(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      return state.profile.loyaltyPointsBalance ?? 0;
    }
    return 0;
  }

  void _handleCheckout(BuildContext context, int loyaltyBalance) {
    if (!_usePoints) {
      widget.onCheckout(0);
      return;
    }

    final entered = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
    final maxByTotal = (widget.grandTotal * 0.5).floor(); // 50% cap


    // Validate: user has no points
    if (loyaltyBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have no loyalty points available to redeem.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate: entered more than they have
    if (entered > loyaltyBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You only have $loyaltyBalance points. Please enter a lower amount.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate: exceeds 50% cap
    if (entered > maxByTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can redeem at most $maxByTotal points (50% of ${widget.grandTotal.round()} EGP total).',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate: must be > 0
    if (entered <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number of points to redeem.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    widget.onCheckout(entered);
  }

  @override
  Widget build(BuildContext context) {
    final loyaltyBalance = _getLoyaltyBalance(context);
    final hasPoints = loyaltyBalance > 0;
    final maxRedeemable = (widget.grandTotal * 0.5).floor();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: ColorsManager.seatContainerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Points redemption section ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _usePoints
                  ? const Color(0xFFFFD700).withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _usePoints
                    ? const Color(0xFFFFD700).withValues(alpha: 0.35)
                    : Colors.white12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Color(0xFFFFD700),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Use Loyalty Points',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            hasPoints
                                ? 'Balance: $loyaltyBalance pts · max $maxRedeemable pts redeemable'
                                : 'No points available yet',
                            style: TextStyle(
                              color: hasPoints
                                  ? const Color(0xFFFFD700)
                                  : Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _usePoints,
                      // Disable toggle if user has no points
                      onChanged: hasPoints
                          ? (val) => setState(() {
                                _usePoints = val;
                                if (!val) _pointsCtrl.clear();
                              })
                          : null,
                      activeTrackColor:
                          const Color(0xFFFFD700).withValues(alpha: 0.5),
                      activeThumbColor: const Color(0xFFFFD700),
                    ),
                  ],
                ),
                if (!hasPoints)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Complete more trips to earn loyalty points.',
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                  ),
                if (_usePoints) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pointsCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          'Points to redeem (1 – $maxRedeemable, you have $loyaltyBalance)',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Capped at 50% of the cart total (max $maxRedeemable pts).',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Grand total ─────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '${widget.grandTotal.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Checkout button ─────────────────────────────────────────
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final isLoading = state is CheckoutLoading;
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _handleCheckout(context, loyaltyBalance),
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
                      : const Text(
                          'Checkout (Wallet)',
                          style: TextStyle(
                            color: Colors.white,
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
