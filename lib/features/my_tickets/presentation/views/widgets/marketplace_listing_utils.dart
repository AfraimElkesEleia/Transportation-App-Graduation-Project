import 'package:flutter/widgets.dart';

class MarketplaceListingDisplay {
  final String originGov;
  final String destinationGov;
  final String? fromLocation;
  final String? toLocation;
  final DateTime departureTime;
  final String agencyName;
  final String className;
  final double oldPrice;
  final double newPrice;
  final String discountLabel;
  final String sellerName;

  const MarketplaceListingDisplay({
    required this.originGov,
    required this.destinationGov,
    required this.fromLocation,
    required this.toLocation,
    required this.departureTime,
    required this.agencyName,
    required this.className,
    required this.oldPrice,
    required this.newPrice,
    required this.discountLabel,
    required this.sellerName,
  });

  String get fromLabel => originGov.isNotEmpty ? originGov : fromLocation ?? '';
  String get toLabel =>
      destinationGov.isNotEmpty ? destinationGov : toLocation ?? '';
  String get fromTo => '$fromLabel \u2192 $toLabel';

  factory MarketplaceListingDisplay.fromJson(
    BuildContext context,
    Map<String, dynamic> item, {
    required String sellerFallback,
    required String standardClassFallback,
  }) {
    final trip = item['tripDetails'] as Map<String, dynamic>? ?? {};
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final originGov = localizedMarketplaceField(
      trip,
      isArabic: isArabic,
      keys: const ['originGovEn', 'originGovernorate', 'originGov'],
      arabicKeys: const ['originGovAr', 'originGovernorateAr'],
    );
    final destinationGov = localizedMarketplaceField(
      trip,
      isArabic: isArabic,
      keys: const [
        'destinationGovEn',
        'destinationGovernorate',
        'destinationGov',
      ],
      arabicKeys: const ['destinationGovAr', 'destinationGovernorateAr'],
    );
    final originCity = localizedMarketplaceField(
      trip,
      isArabic: isArabic,
      keys: const [
        'originStationNameEn',
        'origin',
        'originStation',
        'originName',
      ],
      arabicKeys: const ['originAr', 'originStationNameAr', 'originNameAr'],
    );
    final destinationCity = localizedMarketplaceField(
      trip,
      isArabic: isArabic,
      keys: const [
        'destinationStationNameEn',
        'destination',
        'destinationStation',
        'destinationName',
      ],
      arabicKeys: const [
        'destinationAr',
        'destinationStationNameAr',
        'destinationNameAr',
      ],
    );
    final agencyName = localizedMarketplaceField(
      trip,
      isArabic: isArabic,
      key: 'agencyName',
      arabicKeys: const ['agencyNameAr', 'agencyAr'],
      fallback: localizedMarketplaceField(
        item,
        isArabic: isArabic,
        key: 'agencyName',
        arabicKeys: const ['agencyNameAr', 'agencyAr'],
        fallback: item['agency'] as String?,
      ),
    );
    final className = cleanMarketplaceClassName(
      localizedMarketplaceField(
        trip,
        isArabic: isArabic,
        key: 'class',
        arabicKeys: const ['classNameAr', 'classAr'],
        fallback: standardClassFallback,
      ),
    );
    final timeStr = trip['time'] as String? ?? '';
    final oldPrice = (item['originalPrice'] as num? ?? 0).toDouble();
    final newPrice = (item['askingPrice'] as num? ?? 0).toDouble();

    return MarketplaceListingDisplay(
      originGov: originGov,
      destinationGov: destinationGov,
      fromLocation: originCity.isNotEmpty ? originCity : null,
      toLocation: destinationCity.isNotEmpty ? destinationCity : null,
      departureTime: DateTime.tryParse(timeStr) ?? DateTime.now(),
      agencyName: agencyName,
      className: className,
      oldPrice: oldPrice,
      newPrice: newPrice,
      discountLabel: marketplacePriceChangeLabel(oldPrice, newPrice),
      sellerName: item['sellerName'] as String? ?? sellerFallback,
    );
  }
}

List<dynamic> visibleMarketplaceListings(
  List<dynamic> listings,
  int? currentUserId,
) {
  return listings.where((listing) {
    final item = listing as Map<String, dynamic>;
    final sellerId = item['sellerId'] is int
        ? item['sellerId'] as int
        : int.tryParse('${item['sellerId']}');
    return sellerId == null || sellerId != currentUserId;
  }).toList();
}

String marketplaceAverageDiscount(List<dynamic> listings) {
  if (listings.isEmpty) return '\u2014';
  double sum = 0;
  int validCount = 0;
  for (final listing in listings) {
    final item = listing as Map<String, dynamic>;
    final old = (item['originalPrice'] as num? ?? 0).toDouble();
    final ask = (item['askingPrice'] as num? ?? 0).toDouble();
    if (old > 0 && ask < old) {
      sum += (old - ask) / old * 100;
      validCount++;
    }
  }
  if (validCount == 0) return '\u2014';
  return '${(sum / validCount).round()}%';
}

String marketplacePriceChangeLabel(double oldPrice, double newPrice) {
  final discountVal = oldPrice > 0
      ? ((newPrice - oldPrice) / oldPrice * 100).round()
      : 0;
  return discountVal > 0 ? '+$discountVal%' : '$discountVal%';
}

String cleanMarketplaceClassName(String raw) {
  final parts = raw.split(' - ');
  final seen = <String>{};
  final deduped = parts.where((part) => seen.add(part.trim())).toList();
  return deduped.join(' - ');
}

String localizedMarketplaceField(
  Map<String, dynamic> source, {
  required bool isArabic,
  String? key,
  List<String> keys = const [],
  required List<String> arabicKeys,
  String? fallback,
}) {
  if (isArabic) {
    for (final arabicKey in arabicKeys) {
      final value = source[arabicKey]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
  }

  for (final lookupKey in [...keys, if (key != null) key]) {
    final value = source[lookupKey]?.toString().trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return fallback?.trim() ?? '';
}
