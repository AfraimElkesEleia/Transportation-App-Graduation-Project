import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_date_picker_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_gender_selector.dart';
import 'package:transportation_app/features/signup/presentation/widgets/gender.dart';

class SignupPersonalSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController familyNameController;
  final TextEditingController nationalIdController;
  final Gender? gender;
  final DateTime? dob;
  final String? genderError;
  final String? dobError;
  final Function(Gender?) onGenderChanged;
  final Function(DateTime?) onDobChanged;
  const SignupPersonalSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.familyNameController,
    required this.nationalIdController,
    this.gender,
    this.dob,
    this.genderError,
    this.dobError,
    required this.onGenderChanged,
    required this.onDobChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // First Name
        AppTextFormField(
          label: l10n.firstName,
          hint: l10n.firstNameHint,
          prefixIcon: Icons.person_outline,
          controller: firstNameController,
          validator: AppValidators.firstName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
    
        // Last Name
        AppTextFormField(
          label: l10n.lastName,
          hint: l10n.lastNameHint,
          prefixIcon: Icons.person_2_outlined,
          controller: lastNameController,
          validator: AppValidators.lastName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
    
        // Family Name
        AppTextFormField(
          label: l10n.familyName,
          hint: l10n.familyNameHint,
          prefixIcon: Icons.people_alt_outlined,
          controller: familyNameController,
          validator: AppValidators.familyName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 24),
    
        AppGenderSelector(
          selected: gender,
          onChanged: onGenderChanged,
          errorText: genderError,
        ),
        const SizedBox(height: 24),
    
        // Date of Birth
        AppDatePickerField(
          label: l10n.dateOfBirthLabel,
          selectedDate: dob,
          onDateSelected: onDobChanged,
          errorText: dobError,
          lastDate: DateTime.now(),
          firstDate: DateTime(1900),
        ),
        const SizedBox(height: 24),
    
        // National ID (optional)
        AppTextFormField(
          label: l10n.nationalIdOptional,
          hint: l10n.nationalIdHint,
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          controller: nationalIdController,
          validator: AppValidators.nationalId,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
