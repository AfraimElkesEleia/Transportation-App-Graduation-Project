import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const AuthAccentBar(), 
        const SizedBox(height: 10),
        Text(
          'Create\nAccount.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join the future of travel',
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