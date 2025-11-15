import 'package:flutter/material.dart';

class BlockContainer extends StatelessWidget {
  final Widget child;
  final bool? isVip;
  const BlockContainer({super.key, required this.child, this.isVip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 1, color: Color(0xFF20538D)),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF142a68), Color(0XFF183176)],
        ),
        shadows: isVip != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(
                    0.08,
                  ), // subtle top-glow effect
                  blurRadius: 6,
                  spreadRadius: -2,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
