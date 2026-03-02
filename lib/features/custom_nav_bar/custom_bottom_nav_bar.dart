import 'package:flutter/material.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';

class CustomBottomNavBarItem extends StatefulWidget {
  final bool isActive;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const CustomBottomNavBarItem({
    super.key,
    required this.isActive,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBarItem> createState() => _CustomBottomNavBarItemState();
}

class _CustomBottomNavBarItemState extends State<CustomBottomNavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.forward(from: 0.0);
    } else if (!widget.isActive && oldWidget.isActive) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: ShapeDecoration(
                color: widget.isActive ? Color(0xFF2c6196) : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: widget.isActive
                        ? Color(0xFF3180a4)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceInOut,
                    child: Icon(
                      widget.icon,
                      color: widget.isActive
                          ? Color(0xFF40e0d0)
                          : Colors.white.withOpacity(0.7),
                      size: widget.isActive ? 25 : 20,
                    ),
                  ),
                  verticalSpace(space: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: widget.isActive
                          ? FontWeightHelper.semiBold
                          : FontWeightHelper.regular,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isActive)
              Positioned(
                top: -6,
                left: 0,
                right: 0,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Align(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(),
                        color: Color(0xFF40e0d0),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
