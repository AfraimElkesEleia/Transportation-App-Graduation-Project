import 'package:flutter/material.dart';

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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: _buildButton(
                onTap: resellButton,
                icon: Icons.sell_outlined,
                label: "Resell Tickets",
                color: const Color(0xFF00C853),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildButton(
                onTap: marketPlaceButton,
                icon: Icons.star_border,
                label: "Marketplace",
                color: const Color(0xFF5C6BC0).withOpacity(0.3), // Glassy Blue
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
                  colors: [color.withOpacity(0.4), color.withOpacity(0.1)],
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
