import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';
import '../../core/theme/obsidian_typography.dart';
import '../../core/utils/formatters.dart';

/// Hero balance display with animated counter and subtle breathing ambient aura.
class BalanceDisplay extends StatefulWidget {
  final double balance;
  final double changeAmount;
  final double changePercentage;

  const BalanceDisplay({
    super.key,
    this.balance = 248560.80,
    this.changeAmount = 12840.24,
    this.changePercentage = 5.45,
  });

  @override
  State<BalanceDisplay> createState() => _BalanceDisplayState();
}

class _BalanceDisplayState extends State<BalanceDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Breathing Ambient Glow Behind Balance
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 260,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ObsidianColors.electricLime.withValues(alpha: 0.08),
                      ObsidianColors.electricViolet.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            );
          },
        ),

        // Balance Typographic Content
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TOTAL BALANCE',
                  style: ObsidianTypography.labelCaps,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: ObsidianColors.titaniumLow,
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Main Balance Number
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.balance),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutExpo,
              builder: (context, val, child) {
                return Text(
                  ObsidianFormatters.currency(val),
                  style: ObsidianTypography.heroBalance,
                );
              },
            ),
            const SizedBox(height: 10),

            // Performance Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: ObsidianColors.electricLimeMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ObsidianColors.electricLime.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 14,
                    color: ObsidianColors.electricLime,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${ObsidianFormatters.currency(widget.changeAmount, showSign: true)}  (${ObsidianFormatters.percentage(widget.changePercentage)})',
                    style: ObsidianTypography.trendPositive,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
