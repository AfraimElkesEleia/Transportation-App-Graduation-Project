import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/app_decorations.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const PersonalInfoSection({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        _buildField('Full Name', fullNameController),
        _buildField('Email', emailController),
        _buildField('Phone', phoneController),
        _buildField('Location', locationController),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white54),
        decoration: AppDecorations.profileInput(label).copyWith(
          filled: true,
          fillColor: const Color(0xFF111E2A),
          suffixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.white24,
            size: 16,
          ),
        ),
      ),
    );
  }
}
