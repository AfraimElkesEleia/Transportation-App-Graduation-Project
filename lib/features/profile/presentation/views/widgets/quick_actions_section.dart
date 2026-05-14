import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';

/// Quick actions section listing navigable feature tiles.
class QuickActionsSection extends StatelessWidget {
  final ProfileEntity? profile;
  const QuickActionsSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Quick Actions',
      icon: Icons.flash_on,
      children: [
        _buildActionTile(
          context: context,
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () {
            context.pushNamed(
              AppRoutes.editProfile,
              arguments: {
                'profile': profile,
                'cubit': context.read<ProfileCubit>(),
              },
            );
          },
        ),
        _buildActionTile(
          context: context,
          icon: Icons.stars_rounded,
          title: 'Loyalty Hub',
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.loyaltyHub,
              arguments: {
                'pointsBalance': profile?.loyaltyPointsBalance ?? 0,
                'expiringAmount': profile?.expiringPointsAmount ?? 0,
                'nextExpiryDate': profile?.nextExpiryDate,
              },
            );
          },
        ),
        // _buildActionTile(
        //   context: context,
        //   icon: Icons.lock,
        //   title: 'Privacy & Security',
        //   onTap: () {},
        // ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.cyan),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white54,
      ),
      onTap: onTap,
    );
  }
}
