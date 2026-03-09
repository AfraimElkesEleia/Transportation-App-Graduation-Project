import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';
import 'package:transportation_app/core/theming/app_decorations.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';

/// Personal information section displaying editable text fields and a save button.
class PersonalInfoSection extends StatelessWidget {
  /// Controller for the full name field.
  final TextEditingController fullNameController;

  /// Controller for the email field.
  final TextEditingController emailController;

  /// Controller for the phone field.
  final TextEditingController phoneController;

  /// Controller for the location field.
  final TextEditingController locationController;

  /// Controller for the member-since field.
  final TextEditingController memberSinceController;

  /// Callback when the save button is pressed.
  final VoidCallback? onSave;
  final VoidCallback? onEditTap;
  final VoidCallback? onCancel;
  final bool isEditing;

  const PersonalInfoSection({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.memberSinceController,
    this.onSave,
    required this.isEditing,
    this.onEditTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        if (!isEditing)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEditTap,
              icon: const Icon(Icons.edit, color: Colors.cyan, size: 18),
              label: const Text('Edit', style: TextStyle(color: Colors.cyan)),
            ),
          ),
        _buildTextField('Full Name', fullNameController),
        _buildTextField(
          'Email',
          emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          'Phone',
          phoneController,
          keyboardType: TextInputType.phone,
        ),
        _buildTextField('Location', locationController),
        _buildTextField('Member Since', memberSinceController),
        if (isEditing) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: ColorsManager.cyanBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: !isEditing,
        style: const TextStyle(color: Colors.white),
        decoration: AppDecorations.profileInput(label).copyWith(
          filled: true,
          fillColor: isEditing
              ? const Color(0xFF1A2A3A)
              : const Color(0xFF111E2A),
          suffixIcon: !isEditing
              ? const Icon(Icons.lock_outline, color: Colors.white24, size: 16)
              : null,
        ),
      ),
    );
  }
}
