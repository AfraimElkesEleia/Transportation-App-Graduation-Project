import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';
import 'package:transportation_app/core/l10n/locale_cubit.dart';

/// Quick actions section listing navigable feature tiles.
class QuickActionsSection extends StatelessWidget {
  final ProfileEntity? profile;
  const QuickActionsSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ProfileSectionContainer(
      title: l10n.quickActions,
      icon: Icons.flash_on,
      children: [
        _buildActionTile(
          context: context,
          icon: Icons.person_outline,
          title: l10n.editProfile,
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
          title: l10n.loyaltyHub,
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
        _buildActionTile(
          context: context,
          icon: Icons.support_agent_rounded,
          title: l10n.reportIssue,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.reportIssueScreen);
          },
        ),
        _buildActionTile(
          context: context,
          icon: Icons.assignment_outlined,
          title: l10n.supportTickets,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.supportTicketsScreen);
          },
        ),
        BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            final isArabic = locale.languageCode == 'ar';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language, color: Colors.cyan),
              title: Text(
                l10n.language,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              trailing: ToggleButtons(
                constraints: const BoxConstraints(minHeight: 30, minWidth: 40),
                borderRadius: BorderRadius.circular(8),
                fillColor: Colors.cyan.withValues(alpha: 0.2),
                selectedColor: Colors.cyan,
                color: Colors.white54,
                isSelected: [!isArabic, isArabic],
                onPressed: (i) {
                  context.read<LocaleCubit>().setLocale(i == 0 ? 'en' : 'ar');
                },
                children: const [Text('EN'), Text('ع')],
              ),
            );
          },
        ),
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
