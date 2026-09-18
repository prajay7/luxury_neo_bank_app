import 'package:flutter/material.dart';

/// Design tokens for Obsidian Wealth luxury fintech app.
class ObsidianColors {
  ObsidianColors._();

  // Backgrounds & Void Surfaces
  static const Color obsidianBase = Color(0xFF08090C);
  static const Color obsidianElevated = Color(0xFF0F1116);
  static const Color obsidianSurface = Color(0xFF14161D);
  static const Color obsidianCard = Color(0xFF181B24);
  static const Color obsidianCardHover = Color(0xFF202430);

  // Primary Accent: Electric Lime
  static const Color electricLime = Color(0xFFD2FF00);
  static const Color electricLimeLight = Color(0xFFE2FF4D);
  static const Color electricLimeDim = Color(0xFFAFD500);
  static const Color electricLimeGlow = Color(0x40D2FF00);
  static const Color electricLimeMuted = Color(0x1AD2FF00);

  // Secondary Accent: Electric Violet
  static const Color electricViolet = Color(0xFF8A2BE2);
  static const Color electricVioletLight = Color(0xFFB066FF);
  static const Color electricVioletGlow = Color(0x338A2BE2);
  static const Color electricVioletMuted = Color(0x1F8A2BE2);

  // Auxiliary Market Colors
  static const Color cyanAccent = Color(0xFF00F5D4);
  static const Color gainGreen = Color(0xFF30D158);
  static const Color lossRed = Color(0xFFFF453A);

  // Titanium Grayscale Hierarchy
  static const Color titaniumPure = Color(0xFFFFFFFF);
  static const Color titaniumHigh = Color(0xFFE5E7EB);
  static const Color titaniumMid = Color(0xFF9CA3AF);
  static const Color titaniumLow = Color(0xFF4B5563);
  static const Color titaniumDark = Color(0xFF1F2937);

  // Glassmorphism Strokes & Fills
  static const Color glassFill = Color(0x0FFFFFFF); // 6% white
  static const Color glassFillHigh = Color(0x1AFFFFFF); // 10% white
  static const Color glassStroke = Color(0x1FFFFFFF); // 12% white
  static const Color glassStrokeHighlight = Color(0x33FFFFFF); // 20% white
  static const Color glassStrokeLime = Color(0x4DD2FF00); // 30% lime

  // Card Textures & Gradients
  static const LinearGradient cardBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF222733),
      Color(0xFF141720),
      Color(0xFF0C0E14),
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient metallicGlare = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [
      Color(0x33FFFFFF),
      Color(0x00FFFFFF),
      Color(0x1AD2FF00),
      Color(0x00FFFFFF),
      Color(0x26FFFFFF),
    ],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0],
  );

  static const LinearGradient glassBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40FFFFFF),
      Color(0x0DFFFFFF),
      Color(0x05FFFFFF),
      Color(0x1AD2FF00),
    ],
    stops: [0.0, 0.4, 0.8, 1.0],
  );
}
