import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';

class PointTransactionTile extends StatelessWidget {
  final PointTransaction transaction;

  const PointTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isEarned = transaction.isEarned;
    final color = isEarned ? ColorsManager.successGreen : Colors.redAccent;
    final icon = isEarned ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.borderDim),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.source,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(transaction.createdAt)} · ${transaction.status}',
                  style: const TextStyle(color: ColorsManager.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isEarned ? '+' : ''}${transaction.amount}',
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
