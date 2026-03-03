import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeadline extends StatelessWidget {
  const AuthHeadline({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ],
    );
  }
}
