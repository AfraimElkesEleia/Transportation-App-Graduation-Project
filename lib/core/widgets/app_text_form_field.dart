import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
    this.enabled = true,
  });
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscure;

  // ── Design tokens ─────────────────────────────
  static const _cyan = Color(0xff1AC8E8);
  static const _white20 = Color(0x33FFFFFF); // white @ 20% opacity
  static const _hintColor = Color(0x80FFFFFF); // white @ 50%

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Field label ─────────────────────────
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 4,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 10),

        // ── Input field ─────────────────────────
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _obscure,
          validator: widget.validator,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          enabled: widget.enabled,
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: _hintColor, fontSize: 14),
            prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: _border(Colors.transparent),
            enabledBorder: _border(_white20),
            focusedBorder: _border(_cyan),
            errorBorder: _border(Colors.redAccent),
            focusedErrorBorder: _border(Colors.redAccent),

            // ── Error style ──
            errorStyle: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),

            // ── Fill: subtle dark tint ──
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: color),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
