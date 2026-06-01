import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/validators/app_validators.dart';
import 'package:transportation_app/core/widgets/app_text_form_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_date_picker_field.dart';
import 'package:transportation_app/features/signup/presentation/widgets/app_gender_selector.dart';
import 'package:transportation_app/features/signup/presentation/widgets/gender.dart';

class SignupPersonalSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController familyNameController;
  final TextEditingController idNumberController;
  final Gender? gender;
  final DateTime? dob;
  final String? genderError;
  final String? dobError;
  final int? idType; // null = no ID, 1 = National ID, 2 = Passport
  final Function(int?) onIdTypeChanged;
  final Function(Gender?) onGenderChanged;
  final Function(DateTime?) onDobChanged;

  const SignupPersonalSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.familyNameController,
    required this.idNumberController,
    this.gender,
    this.dob,
    this.genderError,
    this.dobError,
    this.idType,
    required this.onIdTypeChanged,
    required this.onGenderChanged,
    required this.onDobChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

        // ── Optional ID section ────────────────────────────
        _IdTypeSection(
          idType: idType,
          idNumberController: idNumberController,
          onIdTypeChanged: onIdTypeChanged,
          l10n: l10n,
        ),
      ],
    );
  }
}

/// Renders the ID type toggle and the corresponding number field.
class _IdTypeSection extends StatelessWidget {
  final int? idType;
  final TextEditingController idNumberController;
  final Function(int?) onIdTypeChanged;
  final AppLocalizations l10n;

  const _IdTypeSection({
    required this.idType,
    required this.idNumberController,
    required this.onIdTypeChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          l10n.idTypeLabel,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),

        // Toggle row: None / National ID / Passport
        Row(
          children: [
            _IdChip(
              label: l10n.idTypeNone,
              selected: idType == null,
              onTap: () => onIdTypeChanged(null),
            ),
            const SizedBox(width: 8),
            _IdChip(
              label: l10n.idTypeNationalId,
              selected: idType == 1,
              onTap: () => onIdTypeChanged(1),
            ),
            const SizedBox(width: 8),
            _IdChip(
              label: l10n.idTypePassport,
              selected: idType == 2,
              onTap: () => onIdTypeChanged(2),
            ),
          ],
        ),

        // Number field — only shown when a type is selected
        if (idType != null) ...[
          const SizedBox(height: 16),
          AppTextFormField(
            label: idType == 1 ? l10n.idTypeNationalId : l10n.idTypePassport,
            hint: idType == 1 ? l10n.nationalIdHint : l10n.passportNumberHint,
            prefixIcon: idType == 1
                ? Icons.badge_outlined
                : Icons.airplane_ticket_outlined,
            keyboardType: TextInputType.text,
            controller: idNumberController,
            validator: idType == 1
                ? AppValidators.nationalId
                : AppValidators.passportNumber,
            textInputAction: TextInputAction.next,
          ),
        ],
      ],
    );
  }
}

/// A small selectable chip for the ID type toggle.
class _IdChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _IdChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? ColorsManager.accentCyan.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? ColorsManager.accentCyan
                : Colors.white24,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? ColorsManager.accentCyan : Colors.white54,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
