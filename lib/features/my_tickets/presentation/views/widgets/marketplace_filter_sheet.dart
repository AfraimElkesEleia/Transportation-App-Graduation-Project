import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';

/// A bottom sheet for filtering Marketplace listings by origin/destination
/// governorate and travel date, matching the backend's /api/Marketplace/active
/// query parameters.
class MarketplaceFilterSheet extends StatefulWidget {
  final MarketplaceFilter currentFilter;
  final void Function(MarketplaceFilter) onApply;
  final VoidCallback onReset;

  const MarketplaceFilterSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<MarketplaceFilterSheet> createState() => _MarketplaceFilterSheetState();
}

class _MarketplaceFilterSheetState extends State<MarketplaceFilterSheet> {
  late TextEditingController _originCtrl;
  late TextEditingController _destinationCtrl;
  DateTime? _travelDate;

  static const _egyptGovernorates = [
    'Cairo', 'Alexandria', 'Giza', 'Aswan', 'Assiut', 'Luxor', 'Sohag',
    'Qena', 'Beni Suef', 'Fayoum', 'Minya', 'Port Said', 'Suez', 'Ismailia',
    'Damietta', 'Dakahlia', 'Sharqia', 'Kafr El Sheikh', 'Gharbia',
    'Monufia', 'Beheira', 'Qalyubia', 'North Sinai', 'South Sinai',
    'Red Sea', 'New Valley', 'Matrouh',
  ];

  @override
  void initState() {
    super.initState();
    _originCtrl = TextEditingController(text: widget.currentFilter.originGovernorate ?? '');
    _destinationCtrl = TextEditingController(text: widget.currentFilter.destinationGovernorate ?? '');
    _travelDate = widget.currentFilter.travelDate;
  }

  @override
  void dispose() {
    _originCtrl.dispose();
    _destinationCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    final filter = MarketplaceFilter(
      originGovernorate: _originCtrl.text.trim().isEmpty ? null : _originCtrl.text.trim(),
      destinationGovernorate: _destinationCtrl.text.trim().isEmpty ? null : _destinationCtrl.text.trim(),
      travelDate: _travelDate,
    );
    widget.onApply(filter);
    Navigator.pop(context);
  }

  void _reset() {
    widget.onReset();
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
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
    if (picked != null) setState(() => _travelDate = picked);
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return 'Any date';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
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
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),

            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Listings',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset All', style: TextStyle(color: ColorsManager.accentCyan, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Origin Governorate
            _SectionLabel(label: 'Origin Governorate'),
            const SizedBox(height: 10),
            _GovernorateField(
              controller: _originCtrl,
              hint: 'e.g. Cairo',
              governorates: _egyptGovernorates,
              onClear: _originCtrl.text.isNotEmpty ? () => setState(() => _originCtrl.clear()) : null,
            ),
            const SizedBox(height: 20),

            // Destination Governorate
            _SectionLabel(label: 'Destination Governorate'),
            const SizedBox(height: 10),
            _GovernorateField(
              controller: _destinationCtrl,
              hint: 'e.g. Alexandria',
              governorates: _egyptGovernorates,
              onClear: _destinationCtrl.text.isNotEmpty ? () => setState(() => _destinationCtrl.clear()) : null,
            ),
            const SizedBox(height: 20),

            // Travel Date
            _SectionLabel(label: 'Travel Date'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: _travelDate != null
                      ? ColorsManager.accentCyan.withOpacity(0.08)
                      : ColorsManager.surfaceMid,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _travelDate != null ? ColorsManager.accentCyan : ColorsManager.borderSubtle,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: _travelDate != null ? ColorsManager.accentCyan : Colors.white38,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _fmtDate(_travelDate),
                        style: TextStyle(
                          color: _travelDate != null ? ColorsManager.accentCyan : Colors.white54,
                          fontWeight: _travelDate != null ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (_travelDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _travelDate = null),
                        child: const Icon(Icons.close, color: Colors.white38, size: 16),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Apply button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.cyanBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}

/// Text field with autocomplete suggestions from a list of governorates.
class _GovernorateField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final List<String> governorates;
  final VoidCallback? onClear;

  const _GovernorateField({
    required this.controller,
    required this.hint,
    required this.governorates,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable.empty();
        return governorates.where((g) =>
            g.toLowerCase().startsWith(textEditingValue.text.toLowerCase()));
      },
      onSelected: (selection) => controller.text = selection,
      fieldViewBuilder: (ctx, fieldController, focusNode, onFieldSubmitted) {
        // Sync the autocomplete's internal controller with ours on init.
        fieldController.text = controller.text;
        fieldController.addListener(() => controller.text = fieldController.text);
        return TextField(
          controller: fieldController,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            prefixIcon: const Icon(Icons.location_city_outlined, color: Colors.white38, size: 18),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white38, size: 16),
                    onPressed: onClear,
                  )
                : null,
            filled: true,
            fillColor: ColorsManager.surfaceMid,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorsManager.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorsManager.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorsManager.accentCyan, width: 1.5),
            ),
          ),
        );
      },
      optionsViewBuilder: (ctx, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: ColorsManager.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (ctx, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
