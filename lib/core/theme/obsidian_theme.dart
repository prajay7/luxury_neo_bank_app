import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'obsidian_colors.dart';
import 'obsidian_typography.dart';

/// Dark luxury theme for Obsidian Wealth.
class ObsidianTheme {
  ObsidianTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ObsidianColors.obsidianBase,
      primaryColor: ObsidianColors.electricLime,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: ObsidianColors.electricLime,
        onPrimary: ObsidianColors.obsidianBase,
        secondary: ObsidianColors.electricViolet,
        onSecondary: Colors.white,
        surface: ObsidianColors.obsidianSurface,
        onSurface: ObsidianColors.titaniumPure,
        inverseSurface: ObsidianColors.obsidianElevated,
        onInverseSurface: ObsidianColors.titaniumPure,
        error: ObsidianColors.lossRed,
        onError: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF181C26),
        contentTextStyle: const TextStyle(
          color: ObsidianColors.titaniumPure,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ObsidianColors.glassStrokeHighlight, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: ObsidianTypography.screenTitle,
        iconTheme: IconThemeData(color: ObsidianColors.titaniumHigh),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: ObsidianColors.glassStroke,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
