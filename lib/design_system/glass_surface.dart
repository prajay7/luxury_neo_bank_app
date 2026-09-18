import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';

/// Reusable luxury glassmorphic container with frosted blur,
/// dual-gradient border, and optional ambient backlight aura.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? borderGradient;
  final double borderWidth;
  final double blur;
  final Color? auraColor;
  final double auraBlur;
  final VoidCallback? onTap;

  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderGradient,
    this.borderWidth = 1.0,
    this.blur = 18.0,
    this.auraColor,
    this.auraBlur = 32.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? ObsidianColors.glassFill,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );

    // Apply frosted glass blur
    if (blur > 0) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    }

    // Wrap with gradient specular border
    final decorated = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? ObsidianColors.glassStroke,
          width: borderWidth,
        ),
        boxShadow: [
          if (auraColor != null)
            BoxShadow(
              color: auraColor!,
              blurRadius: auraBlur,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: content,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: decorated,
      );
    }

    return decorated;
  }
}
