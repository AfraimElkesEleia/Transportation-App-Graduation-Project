import 'package:flutter/material.dart';

class CustomTicketTabs extends StatefulWidget {
  final List<String> tabLabels;
  final ValueChanged<int> onTabChanged;
  final int initialIndex;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const CustomTicketTabs({
    super.key,
    required this.tabLabels,
    required this.onTabChanged,
    this.initialIndex = 0,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white38,
    this.backgroundColor = const Color(0xFF13285C),
  });

  @override
  State<CustomTicketTabs> createState() => _CustomTicketTabsState();
}

class _CustomTicketTabsState extends State<CustomTicketTabs> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(
      widget.tabLabels.length,
      (index) => index == widget.initialIndex,
    );
  }

  void _handleTap(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
    });
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: List.generate(
            widget.tabLabels.length,
            (index) => Expanded(child: _buildToggleItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(int index) {
    final isActive = _isSelected[index];

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? Border.all(color: Colors.white24)
              : Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isActive ? widget.activeColor : widget.inactiveColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
            child: Text(widget.tabLabels[index]),
          ),
        ),
      ),
    );
  }
}

class CustomToggleBar extends StatelessWidget {
  final List<String> options;
  final List<bool> isSelected;
  final ValueChanged<int> onPressed;
  final Color selectedColor;
  final Color fillColor;
  final BorderRadiusGeometry borderRadius;

  const CustomToggleBar({
    super.key,
    required this.options,
    required this.isSelected,
    required this.onPressed,
    this.selectedColor = Colors.white,
    this.fillColor = const Color(0xFF13285C),
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: fillColor, borderRadius: borderRadius),
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(20),
        selectedBorderColor: Colors.white24,
        borderColor: Colors.transparent,
        fillColor: Colors.white.withOpacity(0.15),
        color: Colors.white38,
        selectedColor: selectedColor,
        constraints: BoxConstraints(
          minHeight: 44,
          minWidth: (MediaQuery.of(context).size.width - 56) / options.length,
        ),
        children: options
            .map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Text(option, style: const TextStyle(fontSize: 14)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
