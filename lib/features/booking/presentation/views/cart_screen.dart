import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart_item_card.dart';

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

  void _onCheckout() {
    context.read<CartCubit>().checkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.seatContainerBg,
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
          
          Object? currentState = state;
          
          if (currentState is CartLoaded) {
            return _buildCartList(currentState);
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
          Icon(Icons.shopping_cart_outlined, size: 80, color: ColorsManager.textMuted),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
            style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.seatContainerBg),
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
          'Checkout successful! Your wallet has been deducted.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.homeScreen);
              },
              style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.accentCyan),
              child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final double grandTotal;
  final VoidCallback onCheckout;

  const _CartBottomBar({
    required this.grandTotal,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: ColorsManager.seatContainerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                '$grandTotal EGP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text(
                'Checkout (Wallet)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
