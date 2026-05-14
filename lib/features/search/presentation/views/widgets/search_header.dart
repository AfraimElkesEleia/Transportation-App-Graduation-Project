import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

class SearchHeader extends StatelessWidget {
  final SearchParams? params;
  final int filterCount;
  final VoidCallback? onFilter;

  const SearchHeader({
    super.key,
    this.params,
    this.filterCount = 0,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final from = params?.fromDisplayName ?? '—';
    final to = params?.toDisplayName ?? '—';
    final date = params?.travelDate ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back
          _CircleButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),

          // Route + date
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        from,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        to,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    color: ColorsManager.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Filter button with active badge
          _FilterButton(filterCount: filterCount, onFilter: onFilter),
        ],
      ),
    );
  }
}

/// Reusable 44×44 circle button used in the header.
class _CircleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _CircleButton({this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      ),
    );
  }
}

/// Filter icon with optional active-count badge.
class _FilterButton extends StatelessWidget {
  final int filterCount;
  final VoidCallback? onFilter;

  const _FilterButton({required this.filterCount, this.onFilter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilter,
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ColorsManager.surfaceMid,
              borderRadius: BorderRadius.circular(22),
              border: filterCount > 0
                  ? Border.all(color: ColorsManager.accentCyan, width: 1.5)
                  : null,
            ),
            child: Icon(
              Icons.tune,
              color: filterCount > 0 ? ColorsManager.accentCyan : Colors.white,
              size: 20,
            ),
          ),
          if (filterCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: ColorsManager.accentCyan,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$filterCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
