import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class CartAppBar extends StatelessWidget {
  final String title;

  const CartAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorsManager.surfaceMid,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorsManager.borderSubtle),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: ColorsManager.accentCyan,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ColorsManager.surfaceMid,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsManager.borderSubtle),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
