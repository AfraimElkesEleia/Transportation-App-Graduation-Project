import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/marketplace_listing_utils.dart';

void showMarketplaceBuyDialog(
  BuildContext context, {
  required Map<String, dynamic> item,
  required MarketplaceCubit cubit,
}) {
  final l10n = AppLocalizations.of(context)!;
  final display = MarketplaceListingDisplay.fromJson(
    context,
    item,
    sellerFallback: l10n.sellerLabel,
    standardClassFallback: l10n.standardClass,
  );
  final originDisplay = [
    display.originGov,
    display.fromLocation,
  ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
  final destinationDisplay = [
    display.destinationGov,
    display.toLocation,
  ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

  showDialog(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx)!;
      return AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.shopping_cart,
              color: ColorsManager.accentCyan,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.buyTicket,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.agencyLabel}: ${display.agencyName.isEmpty ? l10n.unknown : display.agencyName}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              if (originDisplay.isNotEmpty)
                Text(
                  '${l10n.originLabel}: $originDisplay',
                  style: const TextStyle(color: Colors.white70),
                ),
              if (destinationDisplay.isNotEmpty)
                Text(
                  '${l10n.destinationLabel}: $destinationDisplay',
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 8),
              Text(
                '${l10n.dateLabel}: ${display.departureTime.day}/${display.departureTime.month}/${display.departureTime.year}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                '${l10n.timeLabel}: ${display.departureTime.hour.toString().padLeft(2, '0')}:${display.departureTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.classLabel}: ${display.className}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.priceLabel}: ${display.newPrice.toStringAsFixed(2)} ${l10n.egp}',
                style: const TextStyle(
                  color: ColorsManager.successGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.areYouSureBuyTicket,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(
                context,
                AppRoutes.marketplacePassengerFormScreen,
                arguments: {'item': item, 'cubit': cubit},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.successGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n.buyNow,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
