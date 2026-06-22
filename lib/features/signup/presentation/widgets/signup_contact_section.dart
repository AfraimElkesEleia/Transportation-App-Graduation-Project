import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_country_picker_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_phone_field.dart';

class SignupContactSection extends StatelessWidget {
  final void Function(String code, String name) onCountrySelected;

  final void Function(String dialCode, String countryCode)? onDialCodeChanged;

  final TextEditingController emailController;
  final TextEditingController phoneController;

  final String? countryName;
  final String? countryCode;
  final String? countryError;

  final String? selectedDialCode;

  const SignupContactSection({
    super.key,
    required this.onCountrySelected,
    required this.emailController,
    required this.phoneController,
    this.onDialCodeChanged,
    this.countryCode,
    this.countryName,
    this.countryError,
    this.selectedDialCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        AppTextFormField(
          label: l10n.emailLabel,
          hint: l10n.emailHint,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          validator: AppValidators.email,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),

        AppPhoneField(
          label: l10n.phoneNumberLabel,
          controller: phoneController,
          initialDialCode: selectedDialCode ?? '+20',
          onDialCodeChanged: onDialCodeChanged,
          validator: AppValidators.phoneNumber,
        ),
        const SizedBox(height: 24),
        AppCountryPickerField(
          label: l10n.countryLabel,
          selectedCode: countryCode,
          selectedName: countryName,
          onCountrySelected: onCountrySelected,
          errorText: countryError,
        ),
      ],
    );
  }
}
