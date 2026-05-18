import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/presentation/cubit/loyalty_hub_cubit/loyalty_hub_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/loyalty_hub_cubit/loyalty_hub_states.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/challenge_card.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/loyalty_summary_card.dart';
import 'package:transportation_app/features/profile/presentation/views/widgets/point_transaction_tile.dart';

class LoyaltyHubScreen extends StatefulWidget {
  final int pointsBalance;
  final int expiringAmount;
  final String? nextExpiryDate;

  const LoyaltyHubScreen({
    super.key,
    required this.pointsBalance,
    required this.expiringAmount,
    this.nextExpiryDate,
  });

  @override
  State<LoyaltyHubScreen> createState() => _LoyaltyHubScreenState();
}

class _LoyaltyHubScreenState extends State<LoyaltyHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _challengesScroll = ScrollController();
  final ScrollController _pointsScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _challengesScroll.addListener(() {
      if (_challengesScroll.position.pixels >=
          _challengesScroll.position.maxScrollExtent - 200) {
        context.read<LoyaltyHubCubit>().loadChallenges();
      }
    });

    _pointsScroll.addListener(() {
      if (_pointsScroll.position.pixels >=
          _pointsScroll.position.maxScrollExtent - 200) {
        context.read<LoyaltyHubCubit>().loadPointHistory();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _challengesScroll.dispose();
    _pointsScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      appBar: AppBar(
        title: Text(
          l10n.loyaltyHub,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: ColorsManager.surfaceMid,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoyaltySummaryCard(
              pointsBalance: widget.pointsBalance,
              expiringAmount: widget.expiringAmount,
              nextExpiryDate: widget.nextExpiryDate,
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: ColorsManager.accentCyan,
            labelColor: ColorsManager.accentCyan,
            unselectedLabelColor: ColorsManager.textMuted,
            tabs: [
              Tab(text: l10n.challenges),
              Tab(text: l10n.pointsHistory),
            ],
          ),
          Expanded(
            child: BlocBuilder<LoyaltyHubCubit, LoyaltyHubState>(
              builder: (context, state) {
                if (state is LoyaltyHubLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LoyaltyHubError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is LoyaltyHubLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildChallengesTab(state, l10n),
                      _buildPointsTab(state, l10n),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab(LoyaltyHubLoaded state, AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              FilterChip(
                label: Text(l10n.activeChallenges),
                selected: !state.showCompleted,
                onSelected: (val) => context
                    .read<LoyaltyHubCubit>()
                    .toggleChallengeFilter(false),
                selectedColor: ColorsManager.accentCyan.withValues(alpha: 0.2),
                checkmarkColor: ColorsManager.accentCyan,
                labelStyle: TextStyle(
                  color: !state.showCompleted
                      ? ColorsManager.accentCyan
                      : Colors.white70,
                ),
                backgroundColor: ColorsManager.surfaceMid,
              ),
              const SizedBox(width: 12),
              FilterChip(
                label: Text(l10n.completedChallenges),
                selected: state.showCompleted,
                onSelected: (val) =>
                    context.read<LoyaltyHubCubit>().toggleChallengeFilter(true),
                selectedColor: ColorsManager.successGreen.withValues(
                  alpha: 0.2,
                ),
                checkmarkColor: ColorsManager.successGreen,
                labelStyle: TextStyle(
                  color: state.showCompleted
                      ? ColorsManager.successGreen
                      : Colors.white70,
                ),
                backgroundColor: ColorsManager.surfaceMid,
              ),
            ],
          ),
        ),
        Expanded(
          child: state.challenges.isEmpty
              ? Center(
                  child: Text(
                    l10n.noChallengesFound,
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  controller: _challengesScroll,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      state.challenges.length +
                      (state.isLoadingMoreChallenges ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.challenges.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ChallengeCard(challenge: state.challenges[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPointsTab(LoyaltyHubLoaded state, AppLocalizations l10n) {
    if (state.points.isEmpty) {
      return Center(
        child: Text(
          l10n.noPointHistory,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      controller: _pointsScroll,
      padding: const EdgeInsets.all(16),
      itemCount: state.points.length + (state.isLoadingMorePoints ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.points.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return PointTransactionTile(transaction: state.points[index]);
      },
    );
  }
}
