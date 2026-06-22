import 'package:flutter/material.dart';

class CheckoutSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isEmphasized;

  const CheckoutSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
    this.isEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isEmphasized ? Colors.white : Colors.white70,
              fontSize: isEmphasized ? 15 : 13,
              fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: isEmphasized ? 18 : 13,
              fontWeight: isEmphasized ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
