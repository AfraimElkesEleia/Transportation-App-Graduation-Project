import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/cart/checkout_summary_row.dart';

class PaymentSummarySheet extends StatelessWidget {
  final ScrollController scrollController;
  final double cartTotal;
  final double discount;
  final double payableTotal;
  final bool isCheckingOut;
  final VoidCallback onCheckout;

  const PaymentSummarySheet({
    super.key,
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
                  CheckoutSummaryRow(
                    label: l10n.ticketPrice,
                    value: '${cartTotal.toStringAsFixed(2)} ${l10n.egp}',
                  ),
                  const SizedBox(height: 12),
                  CheckoutSummaryRow(
                    label: l10n.pointsDiscount,
                    value: '-${discount.toStringAsFixed(2)} ${l10n.egp}',
                    valueColor: ColorsManager.successGreen,
                  ),
                  const Divider(color: Colors.white24, height: 28),
                  CheckoutSummaryRow(
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
