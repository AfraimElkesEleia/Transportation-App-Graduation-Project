import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';

class MarketplaceFilterBar extends StatelessWidget {
  final bool isFilterActive;
  final VoidCallback onPressed;

  const MarketplaceFilterBar({
    super.key,
    required this.isFilterActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchBarDelegate(
        height: 64,
        child: Container(
          color: ColorsManager.darkBlue,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.tune,
                    size: 18,
                    color: isFilterActive
                        ? ColorsManager.accentCyan
                        : Colors.white,
                  ),
                  label: Text(
                    isFilterActive ? l10n.filtersActive : l10n.filters,
                    style: TextStyle(
                      color: isFilterActive
                          ? ColorsManager.accentCyan
                          : Colors.white,
                      fontWeight: isFilterActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isFilterActive
                          ? ColorsManager.accentCyan
                          : Colors.white24,
                      width: isFilterActive ? 1.5 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: isFilterActive
                        ? ColorsManager.accentCyan.withValues(alpha: 0.08)
                        : Colors.transparent,
                  ),
                ),
              ),
              if (isFilterActive)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ColorsManager.accentCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarketplaceActiveFilterChips extends StatelessWidget {
  final MarketplaceFilter filter;
  final void Function(MarketplaceFilter filter) onChanged;

  const MarketplaceActiveFilterChips({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!filter.isActive) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            if (filter.originGovernorate != null &&
                filter.originGovernorate!.isNotEmpty)
              _ActiveFilterChip(
                label: l10n.filterFrom(filter.originGovernorate!),
                onRemove: () => onChanged(filter.copyWith(clearOrigin: true)),
              ),
            if (filter.destinationGovernorate != null &&
                filter.destinationGovernorate!.isNotEmpty)
              _ActiveFilterChip(
                label: l10n.filterTo(filter.destinationGovernorate!),
                onRemove: () =>
                    onChanged(filter.copyWith(clearDestination: true)),
              ),
            if (filter.travelDate != null)
              _ActiveFilterChip(
                label: l10n.filterDate(
                  '${filter.travelDate!.day}/${filter.travelDate!.month}/${filter.travelDate!.year}',
                ),
                onRemove: () => onChanged(filter.copyWith(clearDate: true)),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _SearchBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SearchBarDelegate old) => true;
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsManager.accentCyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsManager.accentCyan.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: ColorsManager.accentCyan,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
