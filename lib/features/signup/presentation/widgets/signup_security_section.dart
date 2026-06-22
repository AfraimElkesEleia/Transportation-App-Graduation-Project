import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/password_strength_bar.dart';

class SignupSecuritySection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final PasswordStrength passwordStrength;
  final void Function(String password) onChanged;
  final VoidCallback handleSignup;
  const SignupSecuritySection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordStrength,
    required this.onChanged, required this.handleSignup,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Password + strength bar
        AppTextFormField(
          label: l10n.passwordLabel,
          hint: l10n.createPasswordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: passwordController,
          validator: AppValidators.password,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
        PasswordStrengthBar(strength: passwordStrength),
        const SizedBox(height: 20),

        // Confirm Password
        AppTextFormField(
          label: l10n.confirmPasswordLabel,
          hint: l10n.confirmPasswordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: confirmPasswordController,
          validator: (v) =>
              AppValidators.confirmPassword(v, passwordController.text),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => handleSignup(),
        ),
      ],
    );
  }
}
