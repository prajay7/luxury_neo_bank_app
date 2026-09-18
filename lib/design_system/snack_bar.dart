import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';

/// Displays a high-contrast luxury floating SnackBar above the bottom navbar.
void showObsidianSnackBar(
  BuildContext context,
  String message, {
  IconData? icon = Icons.info_outline_rounded,
  Color? iconColor = ObsidianColors.electricLime,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF191D28),
      elevation: 8,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ObsidianColors.glassStrokeHighlight, width: 1),
      ),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: ObsidianColors.titaniumPure,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
      duration: duration,
    ),
  );
}
