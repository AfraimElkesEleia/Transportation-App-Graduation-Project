import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RememberMeRow extends StatelessWidget {
  const RememberMeRow({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff1AC8E8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        Text(
          'Remember me',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {}, 
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: const Color(0xff1AC8E8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
