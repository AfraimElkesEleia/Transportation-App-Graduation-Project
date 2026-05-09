import 'package:flutter/material.dart';
import 'package:transportation_app/core/widgets/app_shimmer.dart';

class SearchLoadingView extends StatelessWidget {
  const SearchLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const AppShimmerCard();
      },
    );
  }
}
