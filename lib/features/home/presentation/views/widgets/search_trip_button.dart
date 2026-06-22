import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class SearchTripButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String? label;
  const SearchTripButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: backgroundColor ?? Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, color: Colors.white, size: 30),
          horizontalSpace(space: 6),
          Text(
            label ?? AppLocalizations.of(context)!.searchTrip,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
