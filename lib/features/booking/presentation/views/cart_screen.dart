import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/booking/domain/entities/cart_entity.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_cubit.dart';
import 'package:transportation_app/features/booking/presentation/cubit/cart_state.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/cart_app_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/checkout_panel.dart';

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
              CartAppBar(title: l10n.myCart),
              Expanded(
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is CartLoaded) {
                      _latestCart = state.cart;
                    } else if (state is CheckoutSuccess) {
                      _showCheckoutSuccessDialog(context, l10n);
                    } else if (state is CheckoutError) {
                      _showErrorSnackBar(context, state.message);
                      context.read<CartCubit>().fetchCart();
                    } else if (state is CartItemCancelError) {
                      _showErrorSnackBar(context, state.message);
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
                      return _buildCartList(state.cart, isCheckingOut: false);
                    }
                    if (state is CheckoutLoading && _latestCart != null) {
                      return _buildCartList(_latestCart!, isCheckingOut: true);
                    }
                    if (state is CartItemCancelling && _latestCart != null) {
                      return _buildCartList(_latestCart!, isCheckingOut: false);
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
    return CheckoutPanel(
      items: cart.items,
      grandTotal: cart.grandTotal,
      isCheckingOut: isCheckingOut,
      onCheckout: _onCheckout,
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ErrorLocalizer.localize(context, message)),
        backgroundColor: Colors.red,
      ),
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
