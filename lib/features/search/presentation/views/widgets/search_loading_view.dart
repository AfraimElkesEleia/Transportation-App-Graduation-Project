import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';

class SearchLoadingView extends StatelessWidget {
  const SearchLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorsManager.accentCyan),
          SizedBox(height: 16),
          Text(
            'Searching for trips...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
