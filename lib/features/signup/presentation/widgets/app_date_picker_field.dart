import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.errorText,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd / MM / yyyy',
  });

  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? errorText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;

  static const _cyan    = Color(0xff1AC8E8);
  static const _white20 = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    final formatted = selectedDate != null
        ? DateFormat(dateFormat).format(selectedDate!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ─────────────────────────────
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 4,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 10),

        // ── Tappable field ────────────────────
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: errorText != null
                    ? Colors.redAccent
                    : _white20,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    formatted ?? 'Select date',
                    style: TextStyle(
                      color: formatted != null
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white54),
              ],
            ),
          ),
        ),

        // ── Validation error ──────────────────
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xff1AC8E8),
              onPrimary: Colors.white,
              surface: Color(0xff0B1F3A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xff081A33),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateSelected(picked);
  }
}