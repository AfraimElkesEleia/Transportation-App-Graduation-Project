import 'package:flutter/material.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/profile_section_container.dart';

/// Quick actions section listing navigable feature tiles.
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Quick Actions',
      icon: Icons.flash_on,
      children: [
        _buildActionTile(Icons.history, 'Booking History'),
        _buildActionTile(Icons.lock, 'Privacy & Security'),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title) {
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
      onTap: () {},
    );
  }
}
