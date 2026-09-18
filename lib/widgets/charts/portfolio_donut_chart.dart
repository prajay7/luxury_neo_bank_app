import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';
import '../../core/utils/formatters.dart';

class DonutSegment {
  final String label;
  final double percentage; // e.g. 52.0 for 52%
  final double amount;
  final Color color;

  const DonutSegment({
    required this.label,
    required this.percentage,
    required this.amount,
    required this.color,
  });
}

/// Segmented glowing portfolio allocation donut chart.
class PortfolioDonutChart extends StatefulWidget {
  final List<DonutSegment> segments;
  final double size;
  final double strokeWidth;
  final ValueChanged<DonutSegment?>? onSegmentSelected;

  const PortfolioDonutChart({
    super.key,
    required this.segments,
    this.size = 220.0,
    this.strokeWidth = 24.0,
    this.onSegmentSelected,
  });

  @override
  State<PortfolioDonutChart> createState() => _PortfolioDonutChartState();
}

class _PortfolioDonutChartState extends State<PortfolioDonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _revealAnimation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _revealAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapSegment(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        widget.onSegmentSelected?.call(null);
      } else {
        _selectedIndex = index;
        widget.onSegmentSelected?.call(widget.segments[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.segments.fold<double>(0, (sum, s) => sum + s.amount);
    final displayedAmount = _selectedIndex != null ? widget.segments[_selectedIndex!].amount : totalAmount;
    final displayedLabel = _selectedIndex != null ? widget.segments[_selectedIndex!].label.toUpperCase() : 'TOTAL INVESTED';
    final displayedColor = _selectedIndex != null ? widget.segments[_selectedIndex!].color : ObsidianColors.titaniumPure;

    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Donut Canvas
            AnimatedBuilder(
              animation: _revealAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DonutChartPainter(
                    segments: widget.segments,
                    progress: _revealAnimation.value,
                    strokeWidth: widget.strokeWidth,
                    selectedIndex: _selectedIndex,
                  ),
                );
              },
            ),

            // Center Content
            GestureDetector(
              onTap: () {
                final nextIndex = _selectedIndex == null
                    ? 0
                    : (_selectedIndex! + 1) % widget.segments.length;
                _onTapSegment(nextIndex);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayedLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: ObsidianColors.titaniumLow,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ObsidianFormatters.compactCurrency(displayedAmount),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: displayedColor,
                    ),
                  ),
                  if (_selectedIndex != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${widget.segments[_selectedIndex!].percentage.toStringAsFixed(0)}% of portfolio',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.segments[_selectedIndex!].color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double progress;
  final double strokeWidth;
  final int? selectedIndex;

  _DonutChartPainter({
    required this.segments,
    required this.progress,
    required this.strokeWidth,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = (size.width - strokeWidth) * 0.5;

    // Draw background track ring
    final trackPaint = Paint()
      ..color = ObsidianColors.glassFillHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    double startAngle = -math.pi * 0.5;
    const gapAngle = 0.08; // Gap spacing between segments

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final isSelected = selectedIndex == i;
      final sweepAngle = ((seg.percentage / 100) * 2 * math.pi * progress) - gapAngle;

      if (sweepAngle > 0) {
        final currentStrokeWidth = isSelected ? strokeWidth + 4 : strokeWidth;

        // Glowing backdrop shadow for selected segment
        if (isSelected) {
          final glowPaint = Paint()
            ..color = seg.color.withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = currentStrokeWidth + 8
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            startAngle + (gapAngle * 0.5),
            sweepAngle,
            false,
            glowPaint,
          );
        }

        final arcPaint = Paint()
          ..color = isSelected ? seg.color : seg.color.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentStrokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + (gapAngle * 0.5),
          sweepAngle,
          false,
          arcPaint,
        );
      }

      startAngle += (seg.percentage / 100) * 2 * math.pi * progress;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.segments != segments;
  }
}
