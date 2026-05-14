import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/constants/api_constants.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/logout_cubit/logout_states.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_app_bar.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_logout_button.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/quick_actions_section.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/loyalty_points_card.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/wallet_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileScreen> {
  Future<void> _onRefresh() async {
    await context.read<ProfileCubit>().loadProfile();
  }

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
              listener: (context, state) {},
            ),
          ],
          child: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (p, c) =>
                c is ProfileLoading ||
                c is ProfileLoaded ||
                c is ProfileError ||
                c is ProfileUpdateSuccess,
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const SafeArea(child: ProfileShimmer());
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
              final profile = state is ProfileLoaded
                  ? state.profile
                  : state is ProfileUpdateSuccess
                  ? state.profile
                  : null;

              return RefreshIndicator(
                color: Colors.cyan,
                backgroundColor: const Color(0xFF112240),
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const ProfileAppBar(),
                      const SizedBox(height: 20),
                      ProfileCard(
                        fullName: profile?.fullName ?? '',
                        email: profile?.email ?? '',
                        profilePictureUrl: ApiConstants.mediaUrl(
                          profile?.profilePictureUrl,
                        ),
                      ),
                      const SizedBox(height: 20),
                      WalletSection(balance: profile?.walletBalance),
                      const SizedBox(height: 20),
                      LoyaltyPointsCard(profile: profile),
                      const SizedBox(height: 20),
                      QuickActionsSection(profile: profile),
                      const SizedBox(height: 30),
                      BlocBuilder<LogoutCubit, LogoutState>(
                        builder: (context, logoutState) {
                          return logoutState is LogoutLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                )
                              : ProfileLogoutButton(
                                  onPressed: _showLogoutDialog,
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
