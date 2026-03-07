import 'package:flutter/material.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_country_picker_field.dart';

class SignupContactSection extends StatelessWidget {
  final void Function(String code, String name) onCountrySelected;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  String? countryName;
  String? countryCode;
  String? countryError;
  SignupContactSection({
    super.key,
    required this.onCountrySelected,
    required this.emailController,
    required this.phoneController,
    this.countryCode,
    this.countryName,
    this.countryError
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email
        AppTextFormField(
          label: 'Email Address',
          hint: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
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
          controller: phoneController,
          validator: AppValidators.phoneNumber,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),

        // Country picker
        AppCountryPickerField(
          label: 'Country',
          selectedCode: countryCode,
          selectedName: countryName,
          onCountrySelected: onCountrySelected,
          errorText: countryError,
        ),
      ],
    );
  }
}
