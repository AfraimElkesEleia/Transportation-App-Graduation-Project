import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/widgets/basic_container.dart';
import 'package:transportation_app/features/multidestination/presentation/widgets/search_section.dart';

class MultidestinationScreen extends StatelessWidget {
  const MultidestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasicContainer(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: verticalSpace(space: 16)),
            SliverToBoxAdapter(child: SearchSection()),
          ],
        ),
      ),
    );
  }
}
