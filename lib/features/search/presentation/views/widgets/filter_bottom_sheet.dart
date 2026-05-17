import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/home/domain/entities/search_params.dart';

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
  late TimeOfDay? _departureFrom;
  late TimeOfDay? _departureTo;
  late TimeOfDay? _arrivalFrom;
  late TimeOfDay? _arrivalTo;

  @override
  void initState() {
    super.initState();
    _transport = widget.activeParams.transport;
    _sortBy = widget.activeParams.sortBy;
    _maxPrice = widget.activeParams.maxPrice;
    _maxPriceSlider = widget.activeParams.maxPrice ?? 1000;
    _departureFrom = widget.activeParams.departureFrom;
    _departureTo = widget.activeParams.departureTo;
    _arrivalFrom = widget.activeParams.arrivalFrom;
    _arrivalTo = widget.activeParams.arrivalTo;
  }

  void _apply() {
    final newParams = widget.activeParams.copyWith(
      transport: _transport,
      sortBy: _sortBy,
      maxPrice: _maxPrice,
      departureFrom: _departureFrom,
      departureTo: _departureTo,
      arrivalFrom: _arrivalFrom,
      arrivalTo: _arrivalTo,
      newPage: 1,
    );
    widget.onApply(newParams);
    Navigator.pop(context);
  }

  void _reset() {
    widget.onReset();
    Navigator.pop(context);
  }

  Future<void> _pickTime(
    TimeOfDay? current,
    void Function(TimeOfDay) onPicked,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: ColorsManager.accentCyan,
            surface: ColorsManager.surfaceDark,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => onPicked(picked));
  }

  String _fmtTime(TimeOfDay? t) {
    if (t == null) return AppLocalizations.of(context)!.any;
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      onTap: () => setState(() => _transport = t),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Max Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(label: l10n.maxPriceText),
                Text(
                  _maxPrice == null
                      ? 'Any'
                      : 'EGP ${_maxPrice!.toStringAsFixed(0)}',
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
                overlayColor: ColorsManager.accentCyan.withOpacity(0.15),
                valueIndicatorColor: ColorsManager.accentCyan,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: _maxPriceSlider,
                min: 50,
                max: 1000,
                divisions: 19,
                label: 'EGP ${_maxPriceSlider.toStringAsFixed(0)}',
                onChanged: (v) => setState(() {
                  _maxPriceSlider = v;
                  _maxPrice = v >= 1000 ? null : v;
                }),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EGP 50',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                Text(
                  'Any',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Departure Time
            _SectionLabel(label: l10n.departureTime),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TimePickerTile(
                    label: 'From',
                    value: _fmtTime(_departureFrom),
                    isSet: _departureFrom != null,
                    onTap: () =>
                        _pickTime(_departureFrom, (t) => _departureFrom = t),
                    onClear: _departureFrom != null
                        ? () => setState(() => _departureFrom = null)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimePickerTile(
                    label: 'To',
                    value: _fmtTime(_departureTo),
                    isSet: _departureTo != null,
                    onTap: () =>
                        _pickTime(_departureTo, (t) => _departureTo = t),
                    onClear: _departureTo != null
                        ? () => setState(() => _departureTo = null)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Arrival Time
            const _SectionLabel(label: 'Arrival Time'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TimePickerTile(
                    label: 'From',
                    value: _fmtTime(_arrivalFrom),
                    isSet: _arrivalFrom != null,
                    onTap: () =>
                        _pickTime(_arrivalFrom, (t) => _arrivalFrom = t),
                    onClear: _arrivalFrom != null
                        ? () => setState(() => _arrivalFrom = null)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimePickerTile(
                    label: 'To',
                    value: _fmtTime(_arrivalTo),
                    isSet: _arrivalTo != null,
                    onTap: () => _pickTime(_arrivalTo, (t) => _arrivalTo = t),
                    onClear: _arrivalTo != null
                        ? () => setState(() => _arrivalTo = null)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

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
              ? ColorsManager.accentCyan.withOpacity(0.12)
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
              ? ColorsManager.accentCyan.withOpacity(0.12)
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

// ── Time picker tile ───────────────────────────────────────────
class _TimePickerTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isSet;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _TimePickerTile({
    required this.label,
    required this.value,
    required this.isSet,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSet
              ? ColorsManager.accentCyan.withOpacity(0.08)
              : ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSet
                ? ColorsManager.accentCyan
                : ColorsManager.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: isSet ? ColorsManager.accentCyan : Colors.white38,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: isSet ? ColorsManager.accentCyan : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, color: Colors.white38, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
