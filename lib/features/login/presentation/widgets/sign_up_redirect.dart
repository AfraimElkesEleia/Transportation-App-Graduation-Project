import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpRedirect extends StatelessWidget {
  const SignUpRedirect({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: const Color(0xff1AC8E8),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
