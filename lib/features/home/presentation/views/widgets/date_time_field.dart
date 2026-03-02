import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';

class DateTimeField extends StatefulWidget {
  const DateTimeField({super.key});

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
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
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          style: AppStyles.regular18white(context),
        ),
        prefixIcon: Icon(Icons.calendar_month, color: ColorsManager.iconsColor),
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
      ),
      onTap: () => selectDate(context),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(21000),
    );
    if (pickedDate != null) {
      String formatted =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        _controller.text = formatted;
      });
    }
  }
}
