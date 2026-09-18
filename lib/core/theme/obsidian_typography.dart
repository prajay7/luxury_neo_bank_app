import 'package:flutter/material.dart';
import 'obsidian_colors.dart';

/// Typography hierarchy for Obsidian Wealth luxury fintech app.
class ObsidianTypography {
  ObsidianTypography._();

  // Hero Display Numbers (e.g. $248,560.80)
  static const TextStyle heroBalance = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.1,
    color: ObsidianColors.titaniumPure,
  );

  // Large Financial Metric (e.g. +$32,840)
  static const TextStyle metricLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.15,
    color: ObsidianColors.titaniumPure,
  );

  // Screen Title (e.g. "Analytics", "My Card")
  static const TextStyle screenTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.6,
    height: 1.2,
    color: ObsidianColors.titaniumPure,
  );

  // Section Header (e.g. "Portfolio", "Recent Activity")
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: ObsidianColors.titaniumHigh,
  );

  // Card Value / Big Subtitle
  static const TextStyle cardValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    color: ObsidianColors.titaniumPure,
  );

  // Body Regular
  static const TextStyle bodyRegular = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.4,
    color: ObsidianColors.titaniumMid,
  );

  // Body Medium
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    color: ObsidianColors.titaniumHigh,
  );

  // Card Number Embossed Text (e.g. "•••• 4821")
  static const TextStyle cardNumber = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.2,
    color: ObsidianColors.titaniumHigh,
  );

  // Micro Labels / Captions (e.g. "TOTAL BALANCE", "EXPIRES")
  static const TextStyle labelCaps = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: ObsidianColors.titaniumMid,
  );

  // Trend Pill Text (e.g. "+5.45%")
  static const TextStyle trendPositive = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: ObsidianColors.electricLime,
  );

  static const TextStyle trendNegative = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: ObsidianColors.lossRed,
  );

  // Button Text
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: ObsidianColors.obsidianBase,
  );

  static const TextStyle buttonGlass = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: ObsidianColors.titaniumHigh,
  );
}
