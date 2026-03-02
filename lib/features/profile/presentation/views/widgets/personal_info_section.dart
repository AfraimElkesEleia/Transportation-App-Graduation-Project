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

  const PersonalInfoSection({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.memberSinceController,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 62),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
            backgroundColor: ColorsManager.cyanBlue,
          ),
          onPressed: onSave,
          child: Text(
            "Save Info",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeightHelper.semiBold,
            ),
          ),
        ),
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
        style: const TextStyle(color: Colors.white),
        decoration: AppDecorations.profileInput(label),
      ),
    );
  }
}
