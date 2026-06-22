import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transportation_app/core/theming/colors.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.05),
        highlightColor: Colors.white.withValues(alpha: 0.15),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class AppShimmerCard extends StatelessWidget {
  const AppShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceMid,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppShimmer(width: 48, height: 48, borderRadius: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppShimmer(width: 120, height: 16),
                  SizedBox(height: 8),
                  AppShimmer(width: 80, height: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const AppShimmer(width: double.infinity, height: 60, borderRadius: 12),
        ],
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          const AppShimmer(width: 120, height: 120, borderRadius: 60),
          const SizedBox(height: 16),
          const AppShimmer(width: 200, height: 24),
          const SizedBox(height: 8),
          const AppShimmer(width: 150, height: 16),
          const SizedBox(height: 32),
          const AppShimmerCard(),
          const AppShimmerCard(),
        ],
      ),
    );
  }
}

// ── Home Screen Shimmer ──────────────────────────────────────────────────────
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        // Fake app-bar area
        SliverToBoxAdapter(
          child: Container(
            height: 100,
            color: ColorsManager.surfaceDark,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
            child: Row(
              children: [
                AppShimmer(width: 40, height: 40, borderRadius: 20),
                const SizedBox(width: 12),
                AppShimmer(width: w * 0.4, height: 20),
                const Spacer(),
                AppShimmer(width: 40, height: 40, borderRadius: 20),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Plan your journey card shimmer
        SliverToBoxAdapter(
          child: _ShimmerBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: w * 0.4, height: 18),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: AppShimmer(width: double.infinity, height: 44, borderRadius: 12)),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer(width: double.infinity, height: 44, borderRadius: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: AppShimmer(width: double.infinity, height: 44, borderRadius: 12)),
                    const SizedBox(width: 12),
                    AppShimmer(width: 44, height: 44, borderRadius: 22),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer(width: double.infinity, height: 44, borderRadius: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                AppShimmer(width: double.infinity, height: 44, borderRadius: 12),
                const SizedBox(height: 12),
                AppShimmer(width: double.infinity, height: 50, borderRadius: 14),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Popular trips shimmer
        SliverToBoxAdapter(
          child: _ShimmerBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: w * 0.35, height: 18),
                const SizedBox(height: 16),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (_, __) => Container(
                      width: 130,
                      margin: const EdgeInsets.only(right: 12),
                      child: AppShimmer(width: 130, height: 110, borderRadius: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Recent searches shimmer
        SliverToBoxAdapter(
          child: _ShimmerBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: w * 0.45, height: 18),
                const SizedBox(height: 16),
                AppShimmer(width: double.infinity, height: 60, borderRadius: 12),
                const SizedBox(height: 10),
                AppShimmer(width: double.infinity, height: 60, borderRadius: 12),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Latest news shimmer
        SliverToBoxAdapter(
          child: _ShimmerBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: w * 0.3, height: 18),
                const SizedBox(height: 16),
                AppShimmer(width: double.infinity, height: 80, borderRadius: 12),
                const SizedBox(height: 10),
                AppShimmer(width: double.infinity, height: 80, borderRadius: 12),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

/// A padded container that mimics BlockContainer for the shimmer layout.
class _ShimmerBlock extends StatelessWidget {
  final Widget child;
  const _ShimmerBlock({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceMid,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
