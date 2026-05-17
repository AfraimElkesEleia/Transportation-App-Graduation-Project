import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

/// Full-width logout button styled in red.
class ProfileLogoutButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  const ProfileLogoutButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.logout, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.signOut,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
