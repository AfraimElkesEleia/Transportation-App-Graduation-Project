import 'package:flutter/material.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/personal_info_section.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_app_bar.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_logout_button.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/quick_actions_section.dart';

/// Main profile screen composing extracted sub-widgets.
///
/// Manages [TextEditingController] lifecycle and delegates rendering
/// to [ProfileAppBar], [ProfileCard], [PersonalInfoSection],
/// [QuickActionsSection], and [ProfileLogoutButton].
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileScreen> {
  final fullNameController = TextEditingController(text: 'Abdelrhman Emad');
  final emailController = TextEditingController(text: 'Abdoemad@gmail.com');
  final phoneController = TextEditingController(text: '+20 1147736580');
  final locationController = TextEditingController(text: 'Cairo, Egypt');
  final memberSinceController = TextEditingController(text: 'Jan 2024');

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    memberSinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ProfileAppBar(),
              const SizedBox(height: 20),
              ProfileCard(
                fullName: fullNameController.text,
                email: emailController.text,
                onEditTap: () {},
              ),
              const SizedBox(height: 20),
              PersonalInfoSection(
                fullNameController: fullNameController,
                emailController: emailController,
                phoneController: phoneController,
                locationController: locationController,
                memberSinceController: memberSinceController,
                onSave: () {},
              ),
              const SizedBox(height: 20),
              const QuickActionsSection(),
              const SizedBox(height: 30),
              ProfileLogoutButton(onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
