import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/theming/app_decorations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/core/widgets/profile_picture_picker.dart';
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

  String? _newImagePath;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _familyNameController = TextEditingController(
      text: widget.profile.familyName,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
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

  // ── Save — upload picture first if picked, then update profile ──
  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_newImagePath != null) {
      // Upload picture first — profile update fires from listener
      context.read<ProfileCubit>().uploadProfilePicture(_newImagePath!);
    } else {
      // No image change — update profile directly
      _updateProfile();
    }
  }

  void _updateProfile() {
    context.read<ProfileCubit>().updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      familyName: _familyNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );
  }

  String get _initials {
    final first = widget.profile.firstName;
    final last = widget.profile.lastName;
    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    return first.isNotEmpty ? first[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfilePictureUploadSuccess) {
              setState(
                () => _uploadedImageUrl = ApiConstants.mediaUrl(state.newUrl),
              );
              _updateProfile();
            }

            if (state is ProfilePictureUploadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo upload failed: ${state.message}'),
                  backgroundColor: Colors.orange,
                  action: SnackBarAction(
                    label: 'Skip & Save',
                    textColor: Colors.white,
                    onPressed: _updateProfile, // save without photo
                  ),
                ),
              );
            }

            // ── Profile updated → pop back ─────────────────
            if (state is ProfileUpdateSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }

            if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isUploadingPicture = state is ProfilePictureUploading;
            final isUpdatingProfile = state is ProfileUpdating;
            final isLoading = isUploadingPicture || isUpdatingProfile;

            return SafeArea(
              child: Column(
                children: [
                  // ── App bar ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                            // ── Profile picture picker ───────
                            ProfilePicturePicker(
                              currentImageUrl:
                                  ApiConstants.mediaUrl(_uploadedImageUrl) ??
                                  ApiConstants.mediaUrl(
                                    widget.profile.profilePictureUrl,
                                  ),
                              initials: _initials,
                              onImagePicked: (path) {
                                setState(() => _newImagePath = path);
                              },
                            ),

                            if (isUploadingPicture) ...[
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      color: Colors.cyan,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Uploading photo...',
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if (_uploadedImageUrl != null) ...[
                              const SizedBox(height: 8),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Photo uploaded',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 24),

                            // ── Editable fields ──────────────
                            ProfileSectionContainer(
                              title: 'Personal Information',
                              icon: Icons.person_outline,
                              children: [
                                _buildField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'First name is required'
                                      : null,
                                ),
                                _buildField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Last name is required'
                                      : null,
                                ),
                                _buildField(
                                  label: 'Family Name',
                                  controller: _familyNameController,
                                ),
                                _buildField(
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) =>
                                      v == null || !v.contains('@')
                                      ? 'Enter a valid email'
                                      : null,
                                ),
                                _buildField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Phone is required'
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ── Points Section ─────────────────
                            ProfileSectionContainer(
                              title: 'Loyalty Points',
                              icon: Icons.stars_rounded,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A2A3A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Earned points are pending until departure and expire 4 months after departure.',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Points Balance: 480',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Expiring Soon: 120 pts (May 31, 2026)',
                                        style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            ProfileSectionContainer(
                              title: 'Fixed Details',
                              icon: Icons.lock_outline,
                              children: [
                                _buildReadOnly(
                                  'Country',
                                  widget.profile.countryName,
                                ),
                                const SizedBox(height: 4),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white38,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Country cannot be changed.',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // ── Save button ──────────────────
                            SizedBox(
                              width: double.infinity,
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
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            isUploadingPicture
                                                ? 'Uploading photo...'
                                                : 'Saving...',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
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
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: AppDecorations.profileInput(
          label,
        ).copyWith(filled: true, fillColor: const Color(0xFF1A2A3A)),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value),
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
