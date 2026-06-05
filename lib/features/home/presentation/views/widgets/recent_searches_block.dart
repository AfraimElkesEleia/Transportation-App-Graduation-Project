import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';
import 'package:transportation_app/features/search/data/models/recent_search_model.dart';
import 'package:transportation_app/features/search/data/datasources/recent_search_local_data_source.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/helper/extensions.dart';

class RecentSearchesList extends StatelessWidget {
  const RecentSearchesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecentSearchModel>>(
      future: sl<RecentSearchLocalDataSource>().getRecentSearches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              AppLocalizations.of(context)!.noRecentSearches,
              style: AppStyles.regular15White(
                context,
              ).copyWith(color: Colors.white70),
            ),
          );
        }

        final searches = snapshot.data!;
        return Column(
          children: searches
              .map((search) => RecentSearchItem(search: search))
              .toList(),
        );
      },
    );
  }
}

class RecentSearchItem extends StatelessWidget {
  final RecentSearchModel search;
  const RecentSearchItem({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Color(0xFF132967),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Reconstruct SearchParams
            final params = SearchParams(
              isRoundTrip: search.isRoundTrip,
              travelDate: search.travelDate,
              returnDate: search.returnDate,
              passengers: search.passengers,
              fromDisplayName: search.fromDisplayName,
              toDisplayName: search.toDisplayName,
              fromGovernorate: search.fromGovernorate,
              fromStationId: search.fromStationId,
              toGovernorate: search.toGovernorate,
              toStationId: search.toStationId,
            );

            // Navigate to SearchScreen directly
            if (params.isRoundTrip) {
              Navigator.pushNamed(
                context,
                AppRoutes.roundTripBookingScreen,
                arguments: params,
              );
            } else {
              Navigator.pushNamed(
                context,
                AppRoutes.searchScreen,
                arguments: params,
              );
            }
          },
          child: recentSearchesItem(context),
        ),
      ),
    );
  }

  ListTile recentSearchesItem(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final from = search.fromDisplayName
        .toLocalizedGov(context)
        .toLocalizedStation(context);
    final to = search.toDisplayName
        .toLocalizedGov(context)
        .toLocalizedStation(context);
    final routeText = search.isRoundTrip ? "$from <-> $to" : "$from -> $to";

    final dateText = search.isRoundTrip && search.returnDate != null
        ? "${search.travelDate} ${l10n.to} ${search.returnDate}"
        : search.travelDate;

    return ListTile(
      leading: FaIcon(
        FontAwesomeIcons.clockRotateLeft,
        color: ColorsManager.cyanBlue,
      ),
      title: Text(
        routeText,
        style: AppStyles.bold18DarkBlue(context).copyWith(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            dateText,
            style: AppStyles.regular15White(context).copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: FaIcon(
        FontAwesomeIcons.chevronRight,
        color: ColorsManager.cyanBlue,
        size: 16,
      ),
    );
  }
}
