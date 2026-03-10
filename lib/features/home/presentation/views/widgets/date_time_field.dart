import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class DateTimeField extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorText;

  const DateTimeField({super.key, this.controller, this.errorText});

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  late final TextEditingController _controller;

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
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
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
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _controller.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      // widget.onDateSelected?.call(pickedDate);
    }
  }
}
