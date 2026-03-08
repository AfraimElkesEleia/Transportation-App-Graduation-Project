import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_gradient_button.dart';
import 'package:transportation_app/core/widgets/auth_background.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_cubit.dart';
import 'package:transportation_app/features/signup/presentation/cubit/signup_state.dart';
import 'package:transportation_app/features/signup/presentation/widgets/gender.dart';
import 'package:transportation_app/features/signup/presentation/widgets/section_label.dart';
import 'package:transportation_app/features/signup/presentation/widgets/signup_contact_section.dart';
import 'package:transportation_app/features/signup/presentation/widgets/signup_header.dart';
import 'package:transportation_app/features/signup/presentation/widgets/signup_personal_section.dart';
import 'package:transportation_app/features/signup/presentation/widgets/signup_security_section.dart';

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
  String? _dialCode = '+20';
  String? _dialCountry = 'EG';

  // ── UI state ──────────────────────────────────────────
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
    final countryErr = _countryCode == null
        ? 'Please select your country.'
        : null;
    setState(() {
      _genderError = genderErr;
      _dobError = dobErr;
      _countryError = countryErr;
    });

    if (genderErr != null || dobErr != null || countryErr != null) ok = false;
    return ok;
  }

  void _handleSignup() {
    final formOk = _formKey.currentState?.validate() ?? false;
    final customOk = _validateCustomFields();
    if (!formOk || !customOk) return;
    final dob =
        '${_dateOfBirth?.year}-'
        '${_dateOfBirth?.month.toString().padLeft(2, '0')}-'
        '${_dateOfBirth?.day.toString().padLeft(2, '0')}';
    context.read<SignupCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      phoneNumber: _buildPhoneNumber(_phoneController.text.trim()),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      familyName: _familyNameController.text.trim(),
      gender: _gender == Gender.male ? 1 : 2,
      dateOfBirth: dob,
      countryCode: _countryCode!,
      nationalIdNumber: _nationalIdController.text.isEmpty
          ? null
          : _nationalIdController.text,
    );
  }

  String _buildPhoneNumber(String input) {
    final trimmed = input.trim();
    if (trimmed.startsWith('+')) return trimmed;
    if (trimmed.startsWith('0')) return '$_dialCode${trimmed.substring(1)}';
    return '$_dialCode$trimmed';
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          print('👁 [Screen] state changed to: $state');
          if (state is SignupSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.homeScreen, (route) => false);
          } else if (state is SignupFailure) {
            print('👁 [Screen] showing snackbar: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SignupHeader(),
                SectionLabel(label: 'Personal Information'),
                const SizedBox(height: 16),
                SignupPersonalSection(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  familyNameController: _familyNameController,
                  nationalIdController: _nationalIdController,
                  onGenderChanged: (g) => setState(() {
                    _gender = g;
                    _genderError = null;
                  }),
                  gender: _gender,
                  dob: _dateOfBirth,
                  dobError: _dobError,
                  genderError: _genderError,
                  onDobChanged: (d) => setState(() {
                    _dateOfBirth = d;
                    _dobError = null;
                  }),
                ),
                // ══════════════════════════════
                // SECTION 2 — Contact
                // ══════════════════════════════
                const SizedBox(height: 32),
                SectionLabel(label: 'Contact Details'),
                const SizedBox(height: 16),

                SignupContactSection(
                  onCountrySelected: (code, name) => setState(() {
                    _countryCode = code;
                    _countryName = name;
                    _countryError = null;
                  }),
                  onDialCodeChanged: (dialCode, countryCode) => setState(() {
                    _dialCode = dialCode;
                    _dialCountry = countryCode;
                  }),
                  emailController: _emailController,
                  phoneController: _phoneController,
                  countryCode: _countryCode,
                  countryName: _countryName,
                  countryError: _countryError,
                  selectedDialCode: _dialCode,
                ),
                // ══════════════════════════════
                // SECTION 3 — Security
                // ══════════════════════════════
                const SizedBox(height: 32),
                SectionLabel(label: 'Security'),
                const SizedBox(height: 16),
                SignupSecuritySection(
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  passwordStrength: _strength,
                  onChanged: (v) => setState(
                    () => _strength = AppValidators.getPasswordStrength(v),
                  ),
                  handleSignup: _handleSignup,
                ),
                const SizedBox(height: 32),

                // ── Create Account button ────────────
                AppGradientButton(
                  label: 'Create Account',
                  onPressed: _handleSignup,
                  isLoading: state is SignupLoading,
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
        ),
      ),
    );
  }
}
