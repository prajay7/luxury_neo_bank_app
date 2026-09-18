import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';
import '../core/theme/obsidian_typography.dart';
import '../core/utils/formatters.dart';
import '../design_system/buttons.dart';
import '../design_system/glass_surface.dart';
import '../design_system/section_header.dart';
import '../widgets/virtual_card/card_tilt_view.dart';
import '../design_system/snack_bar.dart';

/// Screen 2: Dedicated 3D Interactive Card Studio
class CardStudioScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const CardStudioScreen({super.key, this.onBack});

  @override
  State<CardStudioScreen> createState() => _CardStudioScreenState();
}

class _CardStudioScreenState extends State<CardStudioScreen> {
  final GlobalKey<CardTiltViewState> _tiltKey = GlobalKey<CardTiltViewState>();

  bool _isFrozen = false;
  double _dailyLimit = 10000.0;
  bool _onlinePayments = true;
  bool _contactless = true;
  bool _international = false;

  void _showCardDetailsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassSurface(
          borderRadius: 28,
          backgroundColor: ObsidianColors.obsidianElevated.withValues(alpha: 0.95),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ObsidianColors.titaniumLow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Card Security Details', style: ObsidianTypography.sectionHeader),
                  CircularIconButton(
                    icon: Icons.close_rounded,
                    size: 36,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailItem('Full Card Number', '4821 9012 3456 4821'),
              const Divider(height: 20, color: ObsidianColors.glassStroke),
              _buildDetailItem('Cardholder Name', 'Alexander Wright'),
              const Divider(height: 20, color: ObsidianColors.glassStroke),
              Row(
                children: [
                  Expanded(child: _buildDetailItem('Expiry', '11/29')),
                  Expanded(child: _buildDetailItem('CVV', '892', isSecret: true)),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'COPY DETAILS',
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pop();
                  showObsidianSnackBar(
                    context,
                    'Card details copied securely to clipboard.',
                    icon: Icons.check_circle_rounded,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isSecret = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ObsidianTypography.labelCaps),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: ObsidianColors.titaniumPure,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onPressed: widget.onBack,
                  ),
                  const Text('My Card', style: ObsidianTypography.screenTitle),
                  CircularIconButton(
                    icon: Icons.tune_rounded,
                    onPressed: () {
                      showObsidianSnackBar(
                        context,
                        'Card Tier: Obsidian Sovereign Ultra-Metal (Active).',
                        icon: Icons.tune_rounded,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Main 3D Virtual Card Showcase
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CardTiltView(
                  key: _tiltKey,
                  isFrozen: _isFrozen,
                ),
              ),
              const SizedBox(height: 18),

              // Card Title & Interaction Hint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Obsidian Metal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ObsidianColors.titaniumPure,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ObsidianColors.glassFillHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ObsidianColors.glassStroke, width: 0.8),
                    ),
                    child: const Text(
                      '•••• 4821',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: ObsidianColors.titaniumMid,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: ObsidianColors.electricLime.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Drag to tilt in 3D • Tap card to flip',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ObsidianColors.titaniumMid,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Action Buttons: Freeze Card, Details, Replace
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GlassButton(
                      text: _isFrozen ? 'Unfreeze' : 'Freeze',
                      icon: _isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded,
                      textColor: _isFrozen ? Colors.cyan : null,
                      borderColor: _isFrozen ? Colors.cyan.withValues(alpha: 0.5) : null,
                      onPressed: () {
                        setState(() {
                          _isFrozen = !_isFrozen;
                        });
                        showObsidianSnackBar(
                          context,
                          _isFrozen ? 'Card has been frozen temporarily.' : 'Card unfrozen and active.',
                          icon: _isFrozen ? Icons.ac_unit_rounded : Icons.lock_open_rounded,
                          iconColor: _isFrozen ? Colors.cyan : ObsidianColors.electricLime,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      text: 'Details',
                      icon: Icons.visibility_outlined,
                      onPressed: _showCardDetailsModal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      text: 'Replace',
                      icon: Icons.cached_rounded,
                      onPressed: () {
                        showObsidianSnackBar(
                          context,
                          'Replacement Obsidian Titanium card requested.',
                          icon: Icons.credit_card_rounded,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Card Settings & Spending Controls
              const SectionHeader(title: 'Card Controls & Limits'),
              GlassSurface(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DAILY SPENDING LIMIT', style: ObsidianTypography.labelCaps),
                            SizedBox(height: 4),
                            Text('Maximum transaction ceiling', style: ObsidianTypography.bodyRegular),
                          ],
                        ),
                        Text(
                          ObsidianFormatters.currency(_dailyLimit),
                          style: ObsidianTypography.cardValue.copyWith(
                            color: ObsidianColors.electricLime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: ObsidianColors.electricLime,
                        inactiveTrackColor: ObsidianColors.glassFillHigh,
                        thumbColor: ObsidianColors.electricLime,
                        overlayColor: ObsidianColors.electricLime.withValues(alpha: 0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        min: 1000,
                        max: 25000,
                        divisions: 24,
                        value: _dailyLimit,
                        onChanged: (val) => setState(() => _dailyLimit = val),
                      ),
                    ),
                    const Divider(height: 28, color: ObsidianColors.glassStroke),
                    _buildSwitchRow(
                      title: 'Online Payments',
                      subtitle: 'Allow web and in-app transactions',
                      value: _onlinePayments,
                      onChanged: (v) => setState(() => _onlinePayments = v),
                    ),
                    const Divider(height: 28, color: ObsidianColors.glassStroke),
                    _buildSwitchRow(
                      title: 'Contactless NFC',
                      subtitle: 'Apple Pay & physical POS taps',
                      value: _contactless,
                      onChanged: (v) => setState(() => _contactless = v),
                    ),
                    const Divider(height: 28, color: ObsidianColors.glassStroke),
                    _buildSwitchRow(
                      title: 'International Transfers',
                      subtitle: 'Global multi-currency zero-FX fee',
                      value: _international,
                      onChanged: (v) => setState(() => _international = v),
                    ),
                  ],
                ),
              ),

              // Bottom breathing space to safely clear the floating glass nav bar
              const SizedBox(height: 165),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ObsidianTypography.bodyMedium),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: ObsidianColors.titaniumLow)),
          ],
        ),
        Switch.adaptive(
          value: value,
          activeThumbColor: ObsidianColors.obsidianBase,
          activeTrackColor: ObsidianColors.electricLime,
          inactiveTrackColor: ObsidianColors.glassFillHigh,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
