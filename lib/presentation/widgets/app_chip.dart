import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.color,
    this.isVisible = true,
    this.fontSize = 12.0,
    this.borderRadius = 4.0,
    this.backgroundOpacity = 0.12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  });

  final String label;
  final Color color;
  final bool isVisible;
  final double fontSize;
  final double borderRadius;
  final double backgroundOpacity;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
