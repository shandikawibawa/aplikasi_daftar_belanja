import 'package:flutter/material.dart';

/// Widget pill/chip serbaguna dengan styling presisi
class CustomBadge extends StatelessWidget {
  final Widget? icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Border? border;

  const CustomBadge({
    super.key,
    this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 11.5,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.borderRadius = 999.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

