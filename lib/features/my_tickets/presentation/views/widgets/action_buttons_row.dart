import 'package:flutter/material.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class ActionButtonsRow extends StatelessWidget {
  final void Function() resellButton;
  final void Function() marketPlaceButton;
  const ActionButtonsRow({
    super.key,
    required this.resellButton,
    required this.marketPlaceButton,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: _buildButton(
                onTap: resellButton,
                icon: Icons.sell_outlined,
                label: l10n.sellAllTickets,
                color: const Color(0xFF00C853),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                onTap: marketPlaceButton,
                icon: Icons.star_border,
                label: l10n.marketplace,
                color: const Color(0xFF5C6BC0).withValues(alpha: 0.3),
                textColor: Colors.blue[100]!,
                isOutlined: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required void Function() onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(25),
          border: isOutlined ? Border.all(color: Colors.white30) : null,
          gradient: isOutlined
              ? LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.4),
                    color.withValues(alpha: 0.1),
                  ],
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
