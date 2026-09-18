import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';
import '../core/theme/obsidian_typography.dart';
import '../core/utils/formatters.dart';
import '../design_system/buttons.dart';
import '../design_system/section_header.dart';
import '../widgets/charts/portfolio_spline_chart.dart';
import '../widgets/dashboard/balance_display.dart';
import '../widgets/dashboard/transaction_row.dart';
import '../widgets/transfer/quick_transfer_sheet.dart';
import '../widgets/virtual_card/card_tilt_view.dart';
import '../design_system/snack_bar.dart';

/// Screen 1: Wealth Dashboard
class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToCard;
  final VoidCallback onNavigateToAnalytics;

  const DashboardScreen({
    super.key,
    required this.onNavigateToCard,
    required this.onNavigateToAnalytics,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedTimeframe = '1M';

  // Sample data points by timeframe
  final Map<String, List<ChartDataPoint>> _chartData = {
    '1W': [
      const ChartDataPoint(179200, 'Mon'),
      const ChartDataPoint(180450, 'Tue'),
      const ChartDataPoint(182100, 'Wed'),
      const ChartDataPoint(181800, 'Thu'),
      const ChartDataPoint(184300, 'Fri'),
      const ChartDataPoint(185900, 'Sat'),
      const ChartDataPoint(186420, 'Sun'),
    ],
    '1M': [
      const ChartDataPoint(168200, 'Week 1'),
      const ChartDataPoint(172400, 'Week 2'),
      const ChartDataPoint(176900, 'Week 3'),
      const ChartDataPoint(181200, 'Week 4'),
      const ChartDataPoint(186420, 'Current'),
    ],
    '3M': [
      const ChartDataPoint(152000, 'Aug'),
      const ChartDataPoint(164500, 'Sep'),
      const ChartDataPoint(173800, 'Oct'),
      const ChartDataPoint(186420, 'Nov'),
    ],
    '1Y': [
      const ChartDataPoint(135000, 'Q1'),
      const ChartDataPoint(148000, 'Q2'),
      const ChartDataPoint(169000, 'Q3'),
      const ChartDataPoint(186420, 'Q4'),
    ],
  };

  final List<TransactionItem> _transactions = [
    const TransactionItem(
      title: 'Apple Store Fifth Ave',
      category: 'Electronics',
      timestamp: 'Today, 2:45 PM',
      amount: -129.00,
      icon: Icons.apple_rounded,
    ),
    const TransactionItem(
      title: 'Netflix Premium VIP',
      category: 'Entertainment',
      timestamp: 'Yesterday',
      amount: -22.99,
      icon: Icons.movie_outlined,
    ),
    const TransactionItem(
      title: 'Executive Wire Payout',
      category: 'Income / Wire',
      timestamp: 'Oct 24',
      amount: 8500.00,
      icon: Icons.account_balance_wallet_rounded,
      iconColor: ObsidianColors.electricLime,
    ),
    const TransactionItem(
      title: 'Tesla Supercharger',
      category: 'Automotive',
      timestamp: 'Oct 22',
      amount: -420.00,
      icon: Icons.electric_bolt_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeChartData = _chartData[_selectedTimeframe] ?? _chartData['1M']!;

    return Scaffold(
      backgroundColor: ObsidianColors.obsidianBase,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Top Area Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting & Avatar
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ObsidianColors.obsidianElevated,
                          border: Border.all(color: ObsidianColors.glassStrokeHighlight),
                        ),
                        child: const Center(
                          child: Text(
                            'AW',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ObsidianColors.titaniumPure,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: TextStyle(
                              fontSize: 12,
                              color: ObsidianColors.titaniumMid,
                            ),
                          ),
                          Text(
                            'Alexander Wright',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ObsidianColors.titaniumPure,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Notification Icon
                  CircularIconButton(
                    icon: Icons.notifications_none_rounded,
                    hasBadge: true,
                    onPressed: () {
                      showObsidianSnackBar(
                        context,
                        'Obsidian Concierge: All private facilities operational.',
                        icon: Icons.notifications_active_rounded,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Hero Balance Display with Ambient Glow
              const BalanceDisplay(
                balance: 248560.80,
                changeAmount: 12840.24,
                changePercentage: 5.45,
              ),
              const SizedBox(height: 28),

              // Virtual Bank Card with 3D Tilt Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    CardTiltView(
                      onFlipChanged: () {},
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: widget.onNavigateToCard,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app_rounded, size: 13, color: ObsidianColors.titaniumLow),
                          SizedBox(width: 6),
                          Text(
                            'Drag to tilt • Tap card studio for controls',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: ObsidianColors.titaniumLow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions: Send, Request, Analytics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.arrow_upward_rounded,
                    label: 'Send',
                    isPrimary: true,
                    onTap: () => QuickTransferSheet.show(context),
                  ),
                  _buildQuickAction(
                    icon: Icons.arrow_downward_rounded,
                    label: 'Request',
                    onTap: () {
                      showObsidianSnackBar(
                        context,
                        'Private Payment Link generated and copied to clipboard.',
                        icon: Icons.link_rounded,
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.insights_rounded,
                    label: 'Analytics',
                    onTap: widget.onNavigateToAnalytics,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Portfolio Section with Spline Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ObsidianColors.glassFill,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: ObsidianColors.glassStroke, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Gain Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('PORTFOLIO PERFORMANCE', style: ObsidianTypography.labelCaps),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: ObsidianColors.electricLimeMuted,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ObsidianColors.electricLime.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_upward_rounded, size: 12, color: ObsidianColors.electricLime),
                              SizedBox(width: 4),
                              Text('+18.42%', style: ObsidianTypography.trendPositive),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Portfolio Valuation Number
                    Text(
                      ObsidianFormatters.currency(186420.00),
                      style: ObsidianTypography.cardValue.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 16),

                    // Centered Timeframe Selector
                    Center(
                      child: TimeframeSelector(
                        options: const ['1W', '1M', '3M', '1Y'],
                        selected: _selectedTimeframe,
                        onSelected: (val) => setState(() => _selectedTimeframe = val),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PortfolioSplineChart(
                      dataPoints: activeChartData,
                      height: 160,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recent Activity Section
              SectionHeader(
                title: 'Recent Activity',
                actionText: 'View All',
                onAction: () {
                  showObsidianSnackBar(
                    context,
                    'Viewing complete encrypted ledger.',
                    icon: Icons.receipt_long_rounded,
                  );
                },
              ),
              ..._transactions.map((t) => TransactionRow(
                    item: t,
                    onTap: () {
                      showObsidianSnackBar(
                        context,
                        '${t.title}: ${ObsidianFormatters.currency(t.amount, showSign: true)} • Verified',
                        icon: Icons.verified_rounded,
                      );
                    },
                  )),

              // Bottom padding to clear floating nav bar
              const SizedBox(height: 165),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPrimary
                  ? ObsidianColors.electricLime
                  : ObsidianColors.obsidianElevated,
              border: Border.all(
                color: isPrimary
                    ? ObsidianColors.electricLime
                    : ObsidianColors.glassStrokeHighlight,
                width: 1,
              ),
              boxShadow: [
                if (isPrimary)
                  BoxShadow(
                    color: ObsidianColors.electricLime.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Icon(
              icon,
              size: 26,
              color: isPrimary
                  ? ObsidianColors.obsidianBase
                  : ObsidianColors.titaniumHigh,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isPrimary ? ObsidianColors.electricLime : ObsidianColors.titaniumMid,
            ),
          ),
        ],
      ),
    );
  }
}
