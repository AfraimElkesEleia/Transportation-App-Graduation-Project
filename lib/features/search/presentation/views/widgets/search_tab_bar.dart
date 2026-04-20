import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class SearchTabBar extends StatelessWidget {
  final TabController controller;
  final int directCount;
  final int indirectCount;

  const SearchTabBar({
    super.key,
    required this.controller,
    required this.directCount,
    required this.indirectCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        labelColor: ColorsManager.accentCyan,
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: ColorsManager.accentCyan.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsManager.accentCyan, width: 1),
        ),
        tabs: [
          Tab(text: 'Direct ($directCount)'),
          Tab(text: 'Indirect ($indirectCount)'),
        ],
      ),
    );
  }
}
