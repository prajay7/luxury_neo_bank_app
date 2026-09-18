import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';
import '../../core/utils/formatters.dart';

/// Point data model for financial chart.
class ChartDataPoint {
  final double value;
  final String label;

  const ChartDataPoint(this.value, this.label);
}

/// Interactive high-end financial spline chart with glowing neon line,
/// area gradient, entry animation, and interactive touch scrubber.
class PortfolioSplineChart extends StatefulWidget {
  final List<ChartDataPoint> dataPoints;
  final double height;
  final Color lineColor;
  final bool showScrubber;
  final ValueChanged<ChartDataPoint?>? onScrub;

  const PortfolioSplineChart({
    super.key,
    required this.dataPoints,
    this.height = 180.0,
    this.lineColor = ObsidianColors.electricLime,
    this.showScrubber = true,
    this.onScrub,
  });

  @override
  State<PortfolioSplineChart> createState() => _PortfolioSplineChartState();
}

class _PortfolioSplineChartState extends State<PortfolioSplineChart> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _revealAnimation;

  // Touch scrubbing state
  double? _scrubNormalizedX;
  ChartDataPoint? _activePoint;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _revealAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutQuart,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PortfolioSplineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataPoints != widget.dataPoints) {
      _animController.forward(from: 0.0);
      _scrubNormalizedX = null;
      _activePoint = null;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPan(Offset localPosition, double width) {
    final normX = (localPosition.dx / width).clamp(0.0, 1.0);
    final index = ((widget.dataPoints.length - 1) * normX).round();
    final point = widget.dataPoints[index];

    setState(() {
      _scrubNormalizedX = normX;
      _activePoint = point;
    });
    widget.onScrub?.call(point);
  }

  void _onPanEnd() {
    setState(() {
      _scrubNormalizedX = null;
      _activePoint = null;
    });
    widget.onScrub?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Interactive Value Readout Pill when Scrubbing
        SizedBox(
          height: 28,
          child: _activePoint != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: widget.lineColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.lineColor.withValues(alpha: 0.4), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _activePoint!.label,
                            style: const TextStyle(fontSize: 11, color: ObsidianColors.titaniumMid),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ObsidianFormatters.currency(_activePoint!.value),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: widget.lineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 6),

        // Main Canvas
        SizedBox(
          height: widget.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onPanDown: (d) => _onPan(d.localPosition, constraints.maxWidth),
                onPanUpdate: (d) => _onPan(d.localPosition, constraints.maxWidth),
                onPanEnd: (_) => _onPanEnd(),
                onPanCancel: _onPanEnd,
                child: AnimatedBuilder(
                  animation: _revealAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, widget.height),
                      painter: _SplineChartPainter(
                        points: widget.dataPoints,
                        progress: _revealAnimation.value,
                        lineColor: widget.lineColor,
                        scrubNormalizedX: _scrubNormalizedX,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SplineChartPainter extends CustomPainter {
  final List<ChartDataPoint> points;
  final double progress;
  final Color lineColor;
  final double? scrubNormalizedX;

  _SplineChartPainter({
    required this.points,
    required this.progress,
    required this.lineColor,
    this.scrubNormalizedX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final values = points.map((p) => p.value).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    // Padding inside canvas
    const verticalPadding = 16.0;
    final chartHeight = size.height - (verticalPadding * 2);

    // Compute pixel points
    final pixelPoints = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final normalizedY = (points[i].value - minVal) / range;
      final y = size.height - verticalPadding - (normalizedY * chartHeight);
      pixelPoints.add(Offset(x, y));
    }

    // Build smooth cubic bezier path
    final splinePath = Path();
    splinePath.moveTo(pixelPoints[0].dx, pixelPoints[0].dy);

    for (int i = 0; i < pixelPoints.length - 1; i++) {
      final p0 = i > 0 ? pixelPoints[i - 1] : pixelPoints[i];
      final p1 = pixelPoints[i];
      final p2 = pixelPoints[i + 1];
      final p3 = (i + 2 < pixelPoints.length) ? pixelPoints[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

      splinePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    // Clip according to animation progress
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    // Draw Gradient Area Fill under Curve
    final fillPath = Path.from(splinePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, verticalPadding),
        Offset(0, size.height),
        [
          lineColor.withValues(alpha: 0.22),
          lineColor.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw Soft Outer Glow Line
    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.35)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(splinePath, glowPaint);

    // Draw Sharp Foreground Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(splinePath, linePaint);

    canvas.restore();

    // Draw Touch Scrubber Line & Dot
    if (scrubNormalizedX != null) {
      final scrubX = scrubNormalizedX! * size.width;

      // Find Y position by linear segment interpolation
      final segmentCount = points.length - 1;
      final segmentIndex = (scrubNormalizedX! * segmentCount).floor().clamp(0, segmentCount - 1);
      final segmentProgress = (scrubNormalizedX! * segmentCount) - segmentIndex;
      final scrubY = pixelPoints[segmentIndex].dy +
          (pixelPoints[segmentIndex + 1].dy - pixelPoints[segmentIndex].dy) * segmentProgress;

      // Vertical guide line
      final scrubLinePaint = Paint()
        ..color = lineColor.withValues(alpha: 0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(scrubX, 0), Offset(scrubX, size.height), scrubLinePaint);

      // Glowing dot
      canvas.drawCircle(
        Offset(scrubX, scrubY),
        8,
        Paint()..color = lineColor.withValues(alpha: 0.3),
      );
      canvas.drawCircle(
        Offset(scrubX, scrubY),
        4.5,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        Offset(scrubX, scrubY),
        2,
        Paint()..color = ObsidianColors.obsidianBase,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SplineChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrubNormalizedX != scrubNormalizedX ||
        oldDelegate.points != points;
  }
}
