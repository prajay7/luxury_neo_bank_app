import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';
import '../core/theme/obsidian_typography.dart';
import '../core/utils/formatters.dart';
import '../design_system/buttons.dart';
import '../design_system/glass_surface.dart';
import '../design_system/metric_card.dart';
import '../design_system/section_header.dart';
import '../widgets/charts/portfolio_donut_chart.dart';
import '../widgets/charts/portfolio_spline_chart.dart';
import '../design_system/snack_bar.dart';

/// Screen 3: Wealth Analytics & Portfolio Allocation
class AnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AnalyticsScreen({super.key, this.onBack});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = '3M';

  final Map<String, List<ChartDataPoint>> _analyticsData = {
    '1W': [
      const ChartDataPoint(179500, 'Mon'),
      const ChartDataPoint(180900, 'Tue'),
      const ChartDataPoint(182400, 'Wed'),
      const ChartDataPoint(183100, 'Thu'),
      const ChartDataPoint(184700, 'Fri'),
      const ChartDataPoint(185800, 'Sat'),
      const ChartDataPoint(186420, 'Sun'),
    ],
    '1M': [
      const ChartDataPoint(168500, 'Week 1'),
      const ChartDataPoint(173200, 'Week 2'),
      const ChartDataPoint(178400, 'Week 3'),
      const ChartDataPoint(182900, 'Week 4'),
      const ChartDataPoint(186420, 'Now'),
    ],
    '3M': [
      const ChartDataPoint(153580, 'Aug'),
      const ChartDataPoint(161200, 'Sep'),
      const ChartDataPoint(172800, 'Oct'),
      const ChartDataPoint(186420, 'Nov'),
    ],
    '6M': [
      const ChartDataPoint(142000, 'Jun'),
      const ChartDataPoint(148500, 'Jul'),
      const ChartDataPoint(159000, 'Aug'),
      const ChartDataPoint(167000, 'Sep'),
      const ChartDataPoint(177500, 'Oct'),
      const ChartDataPoint(186420, 'Nov'),
    ],
    '1Y': [
      const ChartDataPoint(128000, 'Q1'),
      const ChartDataPoint(144000, 'Q2'),
      const ChartDataPoint(162000, 'Q3'),
      const ChartDataPoint(186420, 'Q4'),
    ],
  };

  final List<DonutSegment> _allocationSegments = const [
    DonutSegment(
      label: 'Stocks',
      percentage: 52.0,
      amount: 96938.40,
      color: ObsidianColors.electricLime,
    ),
    DonutSegment(
      label: 'Crypto',
      percentage: 18.0,
      amount: 33555.60,
      color: ObsidianColors.electricViolet,
    ),
    DonutSegment(
      label: 'Cash',
      percentage: 20.0,
      amount: 37284.00,
      color: ObsidianColors.cyanAccent,
    ),
    DonutSegment(
      label: 'Other',
      percentage: 10.0,
      amount: 18642.00,
      color: ObsidianColors.titaniumMid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeData = _analyticsData[_selectedPeriod] ?? _analyticsData['3M']!;

    return Scaffold(
      backgroundColor: ObsidianColors.obsidianBase,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.onBack != null) ...[
                        CircularIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed: widget.onBack,
                        ),
                        const SizedBox(width: 14),
                      ],
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Analytics', style: ObsidianTypography.screenTitle),
                          Text('Your financial performance', style: TextStyle(fontSize: 13, color: ObsidianColors.titaniumLow)),
                        ],
                      ),
                    ],
                  ),
                  CircularIconButton(
                    icon: Icons.calendar_month_outlined,
                    onPressed: () {
                      showObsidianSnackBar(
                        context,
                        'Period: Last 90 trading days selected.',
                        icon: Icons.calendar_today_rounded,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Hero Growth Metric Card
              GlassSurface(
                borderRadius: 24,
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PORTFOLIO GROWTH', style: ObsidianTypography.labelCaps),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('+\$32,840', style: ObsidianTypography.metricLarge),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ObsidianColors.electricLimeMuted,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: ObsidianColors.electricLime.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_upward_rounded, size: 14, color: ObsidianColors.electricLime),
                              SizedBox(width: 4),
                              Text('+18.42%', style: ObsidianTypography.trendPositive),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Time Controls Pill
                    Center(
                      child: TimeframeSelector(
                        options: const ['1W', '1M', '3M', '6M', '1Y'],
                        selected: _selectedPeriod,
                        onSelected: (p) => setState(() => _selectedPeriod = p),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Main Interactive Financial Chart with Scrubbing
                    PortfolioSplineChart(
                      dataPoints: activeData,
                      height: 170,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Portfolio Allocation Donut Section
              const SectionHeader(
                title: 'Asset Allocation',
                actionText: 'Rebalance',
              ),
              GlassSurface(
                borderRadius: 24,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    PortfolioDonutChart(
                      segments: _allocationSegments,
                      size: 210,
                      strokeWidth: 26,
                    ),
                    const SizedBox(height: 24),

                    // Allocation Category Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _allocationSegments.map((s) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: s.color,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  s.label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ObsidianColors.titaniumHigh,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${s.percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: s.color,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Performance Breakdown Cards
              const SectionHeader(title: 'Class Performance'),
              MetricCard(
                title: 'Global Equities (Stocks)',
                value: ObsidianFormatters.currency(96938.40),
                trend: '+24.8%',
                accentColor: ObsidianColors.electricLime,
              ),
              const SizedBox(height: 10),
              MetricCard(
                title: 'Digital Assets (Crypto)',
                value: ObsidianFormatters.currency(33555.60),
                trend: '+31.4%',
                accentColor: ObsidianColors.electricViolet,
              ),
              const SizedBox(height: 10),
              MetricCard(
                title: 'Treasury & Cash Equivalents',
                value: ObsidianFormatters.currency(37284.00),
                trend: '+4.2%',
                accentColor: ObsidianColors.cyanAccent,
              ),
              const SizedBox(height: 20),

              // View Details Button
              GlassButton(
                text: 'View Full Asset Allocation Report',
                icon: Icons.description_outlined,
                onPressed: () {
                  showObsidianSnackBar(
                    context,
                    'Generating Q4 Wealth Advisory Audit PDF...',
                    icon: Icons.file_download_outlined,
                  );
                },
              ),

              // Bottom breathing space to safely clear the floating glass nav bar
              const SizedBox(height: 165),
            ],
          ),
        ),
      ),
    );
  }
}
