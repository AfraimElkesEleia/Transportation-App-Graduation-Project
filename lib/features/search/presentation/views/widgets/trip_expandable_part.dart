// lib/features/search/presentation/widgets/trip_expandable_section.dart
import 'package:flutter/material.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/search/data/model/route_stops_model.dart';

class TripExpandableSection extends StatefulWidget {
  final List<RouteStopsModel> routeStops;

  const TripExpandableSection({super.key, required this.routeStops});

  @override
  State<TripExpandableSection> createState() => _TripExpandableSectionState();
}

class _TripExpandableSectionState extends State<TripExpandableSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expansion button - minimal rebuild scope
        TextButton.icon(
          onPressed: _toggle,
          icon: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Transform.rotate(
              angle: -180,
              child: const Icon(
                Icons.arrow_back,
                size: 16,
                color: ColorsManager.accentCyan,
              ),
            ),
          ),
          label: Text(
            _isExpanded ? 'Hide Stops' : 'Show Stops',
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),

        // Animated content - ONLY this rebuilds during animation
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRect(
              child: Align(heightFactor: _animation.value, child: child),
            );
          },
          // ✅ CRITICAL: Pass content as child to avoid rebuilding on animation ticks
          child: _isExpanded
              ? _ExpandableContent(routeStops: widget.routeStops)
              : null,
        ),
      ],
    );
  }
}

// ✅ Static content widget - rebuilds ONLY when expanded state changes (not on every animation frame)
class _ExpandableContent extends StatelessWidget {
  final List<RouteStopsModel> routeStops;

  const _ExpandableContent({required this.routeStops});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // ✅ Optional: isolate paint operations
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: ColorsManager.borderSubtle),
            const SizedBox(height: 12),
            const Text(
              'Route Stops',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ...routeStops.map((stop) => _StopRow(stop: stop)),
          ],
        ),
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  final RouteStopsModel stop;

  const _StopRow({required this.stop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Status indicator: origin/destination/intermediate
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: stop.isOrigin || stop.isDestination
                  ? ColorsManager.accentCyan.withOpacity(0.8)
                  : ColorsManager.accentCyan,
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.cardBg, width: 2),
            ),
          ),
          const SizedBox(width: 12),

          // Station name
          Expanded(
            child: Text(
              stop.stationName,
              style: TextStyle(
                color: stop.isOrigin || stop.isDestination
                    ? Colors.white
                    : Colors.white70,
                fontSize: 13,
                fontWeight: stop.isOrigin || stop.isDestination
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),

          // Time - using model's helper (no null checks needed!)
          Text(
            stop.displayTime,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
