import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_gradient_button.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_country_picker_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_date_picker_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_gender_selector.dart';
import 'package:transportation_app/features/signup/presentation/widgets/gender.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ── Form ──────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Controllers (mirrors RegisterRequest fields) ──────
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nationalIdController = TextEditingController();

  // ── Non-text fields ───────────────────────────────────
  Gender? _gender;
  DateTime? _dateOfBirth;
  String? _countryCode;
  String? _countryName;

  // ── UI state ──────────────────────────────────────────
  bool _isLoading = false;
  PasswordStrength _strength = PasswordStrength.none;

  // Manual error strings for non-TextFormField widgets
  String? _genderError;
  String? _dobError;
  String? _countryError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _familyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  // ── Validation helpers for non-Form widgets ───────────

  bool _validateCustomFields() {
    bool ok = true;

    final genderErr = _gender == null ? 'Please select your gender.' : null;
    final dobErr = AppValidators.dateOfBirth(_dateOfBirth);

    setState(() {
      _genderError = genderErr;
      _dobError = dobErr;
    });

    if (genderErr != null || dobErr != null) ok = false;
    return ok;
  }

  void _handleSignup() {
    final formOk = _formKey.currentState?.validate() ?? false;
    final customOk = _validateCustomFields();
    if (!formOk || !customOk) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.pushNamed(AppRoutes.homeScreen);
    });
  }

  // ── Build ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // ── Back ────────────────────────────
            GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // ── Accent bar ──────────────────────
            const AuthAccentBar(),
            const SizedBox(height: 10),

            // ── Headline ────────────────────────
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
            const SizedBox(height: 36),

            // ════════════════════════════════════
            // SECTION 1 — Personal info
            // ════════════════════════════════════
            _SectionLabel(label: 'Personal Information'),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // First Name
                  AppTextFormField(
                    label: 'First Name',
                    hint: 'Enter your first name',
                    prefixIcon: Icons.person_outline,
                    controller: _firstNameController,
                    validator: AppValidators.firstName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Last Name
                  AppTextFormField(
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    prefixIcon: Icons.person_outline,
                    controller: _lastNameController,
                    validator: AppValidators.lastName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Family Name
                  AppTextFormField(
                    label: 'Family Name',
                    hint: 'Enter your family / tribal name',
                    prefixIcon: Icons.people_outline,
                    controller: _familyNameController,
                    validator: AppValidators.familyName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),

                  // Gender selector (outside Form — validated manually)
                  AppGenderSelector(
                    selected: _gender,
                    onChanged: (g) => setState(() {
                      _gender = g;
                      _genderError = null;
                    }),
                    errorText: _genderError,
                  ),
                  const SizedBox(height: 24),

                  // Date of Birth
                  AppDatePickerField(
                    label: 'Date of Birth',
                    selectedDate: _dateOfBirth,
                    onDateSelected: (d) => setState(() {
                      _dateOfBirth = d;
                      _dobError = null;
                    }),
                    errorText: _dobError,
                    lastDate: DateTime.now(),
                    firstDate: DateTime(1900),
                  ),
                  const SizedBox(height: 24),

                  // National ID (optional)
                  AppTextFormField(
                    label: 'National ID Number  (optional)',
                    hint: 'e.g. 29901011234567',
                    prefixIcon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                    controller: _nationalIdController,
                    validator: AppValidators.nationalId,
                    textInputAction: TextInputAction.next,
                  ),

                  // ══════════════════════════════
                  // SECTION 2 — Contact
                  // ══════════════════════════════
                  const SizedBox(height: 32),
                  _SectionLabel(label: 'Contact Details'),
                  const SizedBox(height: 16),

                  // Email
                  AppTextFormField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: AppValidators.email,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  AppTextFormField(
                    label: 'Phone Number',
                    hint: '+201234567890',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: AppValidators.phoneNumber,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),

                  // Country picker
                  AppCountryPickerField(
                    label: 'Country',
                    selectedCode: _countryCode,
                    selectedName: _countryName,
                    onCountrySelected: (code, name) => setState(() {
                      _countryCode = code;
                      _countryName = name;
                      _countryError = null;
                    }),
                    errorText: _countryError,
                  ),

                  // ══════════════════════════════
                  // SECTION 3 — Security
                  // ══════════════════════════════
                  const SizedBox(height: 32),
                  _SectionLabel(label: 'Security'),
                  const SizedBox(height: 16),

                  // Password + strength bar
                  AppTextFormField(
                    label: 'Password',
                    hint: 'Create a strong password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: _passwordController,
                    validator: AppValidators.password,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => setState(
                      () => _strength = AppValidators.getPasswordStrength(v),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _PasswordStrengthBar(strength: _strength),
                  const SizedBox(height: 20),

                  // Confirm Password
                  AppTextFormField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (v) => AppValidators.confirmPassword(
                      v,
                      _passwordController.text,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSignup(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Create Account button ────────────
            AppGradientButton(
              label: 'Create Account',
              onPressed: _handleSignup,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),

            // ── Sign In redirect ─────────────────
            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign In',
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
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Local sub-widgets
// ─────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1AC8E8), Color(0xff1E5EFF)],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ],
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: strength.progress,
            minHeight: 6,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(strength.colorValue),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          strength.label,
          style: TextStyle(
            color: Color(strength.colorValue),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
