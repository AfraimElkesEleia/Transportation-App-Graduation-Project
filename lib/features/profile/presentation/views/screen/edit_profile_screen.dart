import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: BasicContainer(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfilePictureUploadSuccess) {
              setState(() => _uploadedImageUrl = state.newUrl);
              _updateProfile();
            }

            if (state is ProfilePictureUploadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.photoUploadFailed(state.message)),
                  backgroundColor: Colors.orange,
                  action: SnackBarAction(
                    label: l10n.skipAndSave,
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
                SnackBar(
                  content: Text(l10n.profileUpdatedSuccessfully),
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
                        Expanded(
                          child: Text(
                            l10n.editProfile,
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
                              currentImageUrl: ApiConstants.mediaUrl(
                                _uploadedImageUrl ??
                                    widget.profile.profilePictureUrl,
                              ),
                              initials: widget.profile.initials,
                              onImagePicked: (path) {
                                setState(() => _newImagePath = path);
                              },
                            ),

                            if (isUploadingPicture) ...[
                              const SizedBox(height: 12),
                              Row(
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
                                    l10n.uploadingPhoto,
                                    style: const TextStyle(
                                      color: Colors.cyan,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if (_uploadedImageUrl != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    l10n.photoUploaded,
                                    style: const TextStyle(
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
                              title: l10n.sectionPersonal,
                              icon: Icons.person_outline,
                              children: [
                                _buildField(
                                  label: l10n.firstName,
                                  controller: _firstNameController,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? l10n.firstNameRequired
                                      : null,
                                ),
                                _buildField(
                                  label: l10n.lastName,
                                  controller: _lastNameController,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? l10n.lastNameRequired
                                      : null,
                                ),
                                _buildField(
                                  label: l10n.familyName,
                                  controller: _familyNameController,
                                ),
                                _buildField(
                                  label: l10n.emailLabel,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) =>
                                      v == null || !v.contains('@')
                                      ? l10n.emailAddressValid
                                      : null,
                                ),
                                _buildField(
                                  label: l10n.phoneNumberLabel,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? l10n.phoneNumberRequired
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // ── Fixed Details Section ──────────
                            _FixedDetailsSection(profile: widget.profile),
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
                                                ? l10n.uploadingPhoto
                                                : l10n.saving,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        l10n.saveChanges,
                                        style: const TextStyle(
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
}

class _FixedDetailsSection extends StatelessWidget {
  final ProfileEntity profile;

  const _FixedDetailsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Resolve id type label
    String? idTypeLabel;
    if (profile.idType == 1) {
      idTypeLabel = l10n.idTypeNationalId;
    } else if (profile.idType == 2) {
      idTypeLabel = l10n.idTypePassport;
    }

    return ProfileSectionContainer(
      title: l10n.fixedDetails,
      icon: Icons.lock_outline,
      children: [
        _buildReadOnly(l10n.countryLabel, profile.countryName),
        if (idTypeLabel != null) ...[
          const SizedBox(height: 4),
          _buildReadOnly(l10n.idTypeLabel, idTypeLabel),
        ],
        if (profile.idNumber != null && profile.idNumber!.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildReadOnly(
            profile.idType == 2 ? l10n.passportNumberLabel : l10n.idNumberLabel,
            profile.idNumber!,
          ),
        ],
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white38, size: 14),
            const SizedBox(width: 6),
            Text(
              l10n.countryCannotBeChanged,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ],
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
