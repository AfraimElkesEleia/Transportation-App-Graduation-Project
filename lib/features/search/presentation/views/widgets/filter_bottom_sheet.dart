import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

/// The three bus companies available in the system.
const List<String> kBusCompanies = ['Blue Bus', 'GoBus', 'Horus'];

class FilterBottomSheet extends StatefulWidget {
  final SearchParams activeParams;
  final void Function(SearchParams) onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.activeParams,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TransportType _transport;
  late SortBy _sortBy;
  late double _maxPriceSlider;
  late double? _maxPrice;
  late Set<String> _selectedAgencies;

  @override
  void initState() {
    super.initState();
    _transport = widget.activeParams.transport;
    _sortBy = widget.activeParams.sortBy;
    _maxPrice = widget.activeParams.maxPrice;
    _maxPriceSlider = widget.activeParams.maxPrice ?? 1000;
    _selectedAgencies = Set<String>.from(widget.activeParams.preferredAgencies);
  }

  void _apply() {
    final newParams = widget.activeParams.copyWith(
      transport: _transport,
      sortBy: _sortBy,
      maxPrice: _maxPrice,
      clearTimeFilters: true,
      // Only send agencies when Bus is selected and specific ones chosen
      preferredAgencies: (_transport == TransportType.bus && _selectedAgencies.isNotEmpty)
          ? _selectedAgencies.toList()
          : [],
      newPage: 1,
    );
    widget.onApply(newParams);
    Navigator.pop(context);
  }

  void _reset() {
    widget.onReset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBus = _transport == TransportType.bus;

    return Container(
      decoration: const BoxDecoration(
        color: ColorsManager.surfaceDarker,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Title + reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.filters,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    l10n.reset,
                    style: const TextStyle(
                      color: ColorsManager.accentCyan,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Sort By
            _SectionLabel(label: l10n.sortBy),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SortBy.values.map((s) {
                final selected = _sortBy == s;
                String label;
                switch (s) {
                  case SortBy.departureTime:
                    label = l10n.departureTime;
                    break;
                  case SortBy.lowestPrice:
                    label = l10n.lowestPrice;
                    break;
                  case SortBy.shortestDuration:
                    label = l10n.shortestDuration;
                    break;
                }
                return _FilterChip(
                  label: label,
                  selected: selected,
                  onTap: () => setState(() => _sortBy = s),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Transport
            _SectionLabel(label: l10n.transportType),
            const SizedBox(height: 12),
            Row(
              children: TransportType.values.map((t) {
                final selected = _transport == t;
                String label;
                switch (t) {
                  case TransportType.all:
                    label = l10n.all;
                    break;
                  case TransportType.bus:
                    label = l10n.bus;
                    break;
                  case TransportType.train:
                    label = l10n.train;
                    break;
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _TransportTile(
                      label: label,
                      icon: _transportIcon(t),
                      selected: selected,
                      onTap: () => setState(() {
                        _transport = t;
                        // Clear agency selection when switching away from Bus
                        if (t != TransportType.bus) {
                          _selectedAgencies.clear();
                        }
                      }),
                    ),
                  ),
                );
              }).toList(),
            ),

            // ── Company selector (animated, only when Bus is selected)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isBus
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _CompanySelector(
                        label: l10n.chooseCompany,
                        allLabel: l10n.allCompanies,
                        companies: kBusCompanies,
                        selected: _selectedAgencies,
                        onChanged: (updated) =>
                            setState(() => _selectedAgencies = updated),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 28),

            // ── Max Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(label: l10n.maxPriceText),
                Text(
                  _maxPrice == null
                      ? l10n.any
                      : '${l10n.egp} ${_maxPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: ColorsManager.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ColorsManager.accentCyan,
                inactiveTrackColor: ColorsManager.surfaceMid,
                thumbColor: ColorsManager.accentCyan,
                overlayColor: ColorsManager.accentCyan.withValues(alpha: 0.15),
                valueIndicatorColor: ColorsManager.accentCyan,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: _maxPriceSlider,
                min: 50,
                max: 1000,
                divisions: 19,
                label: '${l10n.egp} ${_maxPriceSlider.toStringAsFixed(0)}',
                onChanged: (v) => setState(() {
                  _maxPriceSlider = v;
                  _maxPrice = v >= 1000 ? null : v;
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.egp} 50',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                Text(
                  l10n.any,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Apply button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.cyanBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.apply,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  IconData _transportIcon(TransportType t) {
    switch (t) {
      case TransportType.all:
        return Icons.directions;
      case TransportType.bus:
        return Icons.directions_bus;
      case TransportType.train:
        return Icons.train;
    }
  }
}

// ── Company selector section ───────────────────────────────────
class _CompanySelector extends StatelessWidget {
  final String label;
  final String allLabel;
  final List<String> companies;
  final Set<String> selected;
  final void Function(Set<String>) onChanged;

  const _CompanySelector({
    required this.label,
    required this.allLabel,
    required this.companies,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isAllSelected = selected.isEmpty;

    // All items: individual companies + "All companies" at the end
    final tiles = <_CompanyItem>[
      ...companies.map(
        (c) => _CompanyItem(
          name: c,
          isSelected: selected.contains(c),
          onTap: () {
            final next = Set<String>.from(selected);
            if (next.contains(c)) {
              next.remove(c);
            } else {
              next.add(c);
            }
            onChanged(next);
          },
        ),
      ),
      _CompanyItem(
        name: allLabel,
        isSelected: isAllSelected,
        isAllOption: true,
        onTap: () => onChanged({}),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceMid.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: label),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.8,
            children: tiles,
          ),
        ],
      ),
    );
  }
}

class _CompanyItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isAllOption;
  final VoidCallback onTap;

  const _CompanyItem({
    required this.name,
    required this.isSelected,
    required this.onTap,
    this.isAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isAllOption
                  ? Colors.white.withValues(alpha: 0.08)
                  : ColorsManager.accentCyan.withValues(alpha: 0.12))
              : ColorsManager.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? (isAllOption ? Colors.white38 : ColorsManager.accentCyan)
                : ColorsManager.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? (isAllOption ? Colors.white70 : ColorsManager.accentCyan)
                : Colors.white54,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ── Sort chip ──────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? ColorsManager.accentCyan.withValues(alpha: 0.12)
              : ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? ColorsManager.accentCyan
                : ColorsManager.borderSubtle,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? ColorsManager.accentCyan : Colors.white54,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Transport tile ─────────────────────────────────────────────
class _TransportTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TransportTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? ColorsManager.accentCyan.withValues(alpha: 0.12)
              : ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? ColorsManager.accentCyan
                : ColorsManager.borderSubtle,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? ColorsManager.accentCyan : Colors.white38,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? ColorsManager.accentCyan : Colors.white54,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
