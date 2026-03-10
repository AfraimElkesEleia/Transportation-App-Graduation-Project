import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/app_decorations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _familyNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController  = TextEditingController(text: widget.profile.firstName);
    _lastNameController   = TextEditingController(text: widget.profile.lastName);
    _familyNameController = TextEditingController(text: widget.profile.familyName);
    _emailController      = TextEditingController(text: widget.profile.email);
    _phoneController      = TextEditingController(text: widget.profile.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _familyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ProfileCubit>().updateProfile(
      firstName:   _firstNameController.text.trim(),
      lastName:    _lastNameController.text.trim(),
      familyName:  _familyNameController.text.trim(),
      email:       _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              Navigator.pop(context); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:         Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:         Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileUpdating;

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:      Colors.white,
                              fontSize:   20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ProfileSectionContainer(
                              title: 'Personal Information',
                              icon:  Icons.person_outline,
                              children: [
                                _buildField(
                                  label:      'First Name',
                                  controller: _firstNameController,
                                  validator:  (v) => v == null || v.trim().isEmpty
                                      ? 'First name is required' : null,
                                ),
                                _buildField(
                                  label:      'Last Name',
                                  controller: _lastNameController,
                                  validator:  (v) => v == null || v.trim().isEmpty
                                      ? 'Last name is required' : null,
                                ),
                                _buildField(
                                  label: 'Family Name',
                                  controller: _familyNameController,
                                ),
                                _buildField(
                                  label:        'Email',
                                  controller:   _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator:    (v) => v == null || !v.contains('@')
                                      ? 'Enter a valid email' : null,
                                ),
                                _buildField(
                                  label:        'Phone Number',
                                  controller:   _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator:    (v) => v == null || v.trim().isEmpty
                                      ? 'Phone is required' : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            ProfileSectionContainer(
                              title: 'Fixed Details',
                              icon:  Icons.lock_outline,
                              children: [
                                _buildReadOnly('Country', widget.profile.countryName),
                                const SizedBox(height: 4),
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.white38, size: 14),
                                    SizedBox(width: 6),
                                    Text(
                                      'Country cannot be changed.',
                                      style: TextStyle(color: Colors.white38, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            SizedBox(
                              width:  double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleSave,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsManager.cyanBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color:      Colors.white,
                                          fontSize:   18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required String                label,
    required TextEditingController controller,
    TextInputType                  keyboardType = TextInputType.text,
    String? Function(String?)?     validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller:   controller,
        keyboardType: keyboardType,
        validator:    validator,
        style: const TextStyle(color: Colors.white),
        decoration: AppDecorations.profileInput(label).copyWith(
          filled:    true,
          fillColor: const Color(0xFF1A2A3A),
        ),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly:   true,
        style: const TextStyle(color: Colors.white54),
        decoration: AppDecorations.profileInput(label).copyWith(
          filled:    true,
          fillColor: const Color(0xFF111E2A),
          suffixIcon: const Icon(Icons.lock_outline, color: Colors.white24, size: 16),
        ),
      ),
    );
  }
}
