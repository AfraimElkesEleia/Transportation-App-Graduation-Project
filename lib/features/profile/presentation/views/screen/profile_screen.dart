import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_states.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
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
  bool _isEditing = false;
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

  void _fillControllers(ProfileLoaded state) {
    fullNameController.text = state.profile.fullName;
    emailController.text = state.profile.email;
    phoneController.text = state.profile.phoneNumber;
    locationController.text = state.profile.countryName;
    memberSinceController.text = ''; // fill when backend provides it
  }

  // ── Logout confirmation dialog ───────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A2A3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You will need to sign in again to access your account.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<LogoutCubit>().logout();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: MultiBlocListener(
          listeners: [
            BlocListener<LogoutCubit, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.loginScreen,
                    (_) => false,
                  );
                }
              },
            ),
            BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  _fillControllers(state);
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.cyan),
                );
              }
              if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              final profile = state is ProfileLoaded ? state.profile : null;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const ProfileAppBar(),
                    const SizedBox(height: 20),
                    ProfileCard(
                      fullName: profile?.fullName ?? '',
                      email: profile?.email ?? '',
                    ),
                    const SizedBox(height: 20),
                    PersonalInfoSection(
                      fullNameController: fullNameController,
                      emailController: emailController,
                      phoneController: phoneController,
                      locationController: locationController,
                      memberSinceController: memberSinceController,
                      isEditing: _isEditing,
                      onSave: () {
                        setState(() => _isEditing = false);
                      },
                      onEditTap: () => setState(() {
                        _isEditing = true;
                      }),
                      onCancel: () {
                        setState(() {
                          _isEditing = false;
                        });
                        _fillControllers(
                          context.read<ProfileCubit>().state as ProfileLoaded,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const QuickActionsSection(),
                    const SizedBox(height: 30),
                    BlocBuilder<LogoutCubit, LogoutState>(
                      builder: (context, logoutState) {
                        return logoutState is LogoutLoading
                            ? const CircularProgressIndicator(color: Colors.red)
                            : ProfileLogoutButton(onPressed: _showLogoutDialog);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
