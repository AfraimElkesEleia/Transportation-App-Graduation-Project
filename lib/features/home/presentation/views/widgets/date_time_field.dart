import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class DateTimeField extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorText;
  final DateTime? minimumDate;
  final ValueChanged<DateTime>? onDateSelected;

  const DateTimeField({
    super.key, 
    this.controller, 
    this.errorText,
    this.minimumDate,
    this.onDateSelected,
  });

  @override
  State<DateTimeField> createState() => DateTimeFieldState();
}

class DateTimeFieldState extends State<DateTimeField> {
  late final TextEditingController _controller;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _latestTravelDate => _today.add(const Duration(days: 60));

  DateTime? get _selectedDate {
    final parts = _controller.text.trim().split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  String _formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      style: AppStyles.regular18white(context),
      decoration: InputDecoration(
        hint: Text(
          AppLocalizations.of(context)!.selectDate,
          style: AppStyles.regular18white(context),
        ),
        prefixIcon: Icon(Icons.calendar_month, color: ColorsManager.iconsColor),
        errorText: widget.errorText,
        errorStyle: const TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: ColorsManager.iconsColor, width: 5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorsManager.iconsColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorsManager.iconsColor,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      onTap: () => selectDate(),
    );
  }

  Future<void> selectDate() async {
    final firstDate = widget.minimumDate ?? _today;
    final selectedDate = _selectedDate;
    final initialDate =
        selectedDate != null && !selectedDate.isBefore(firstDate)
        ? selectedDate
        : firstDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: _latestTravelDate,
    );
    if (pickedDate != null) {
      _controller.text = _formatDisplayDate(pickedDate);
      widget.onDateSelected?.call(pickedDate);
    }
  }
}
