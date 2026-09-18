import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';
import '../../core/theme/obsidian_typography.dart';
import '../../core/utils/formatters.dart';
import '../../design_system/buttons.dart';
import 'particle_burst.dart';
import 'slide_to_send.dart';

class QuickTransferSheet extends StatefulWidget {
  const QuickTransferSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickTransferSheet(),
    );
  }

  @override
  State<QuickTransferSheet> createState() => _QuickTransferSheetState();
}

class _QuickTransferSheetState extends State<QuickTransferSheet> {
  double _amount = 2500.00;
  int _selectedRecipientIndex = 0;
  bool _isSuccess = false;

  final List<Map<String, String>> _recipients = [
    {'name': 'Sarah Williams', 'account': '•••• 2184', 'initials': 'SW'},
    {'name': 'Marcus Vance', 'account': '•••• 7710', 'initials': 'MV'},
    {'name': 'Elena Rostova', 'account': '•••• 9342', 'initials': 'ER'},
    {'name': 'Oliver Sterling', 'account': '•••• 3105', 'initials': 'OS'},
  ];

  final List<double> _quickAmounts = [500, 1000, 2500, 5000];

  Future<void> _handleSend() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() {
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRecipient = _recipients[_selectedRecipientIndex];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: ObsidianColors.obsidianBase.withValues(alpha: 0.92),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(
                color: ObsidianColors.glassStrokeHighlight,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.9),
                  blurRadius: 40,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (!_isSuccess)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Drag Handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: ObsidianColors.titaniumLow,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Send Money', style: ObsidianTypography.screenTitle),
                          CircularIconButton(
                            icon: Icons.close_rounded,
                            size: 38,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Recipient Selection Row
                      const Text(
                        'SELECT RECIPIENT',
                        style: ObsidianTypography.labelCaps,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recipients.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final r = _recipients[index];
                            final isSelected = index == _selectedRecipientIndex;

                            return GestureDetector(
                              onTap: () => setState(() => _selectedRecipientIndex = index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ObsidianColors.electricLime.withValues(alpha: 0.12)
                                      : ObsidianColors.glassFill,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? ObsidianColors.electricLime
                                        : ObsidianColors.glassStroke,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? ObsidianColors.electricLime
                                            : const Color(0xFF262C3A),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: ObsidianColors.electricLime.withValues(alpha: 0.4),
                                                  blurRadius: 8,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          r['initials']!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: isSelected
                                                ? ObsidianColors.obsidianBase
                                                : ObsidianColors.titaniumHigh,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          r['name']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: ObsidianColors.titaniumPure,
                                          ),
                                        ),
                                        Text(
                                          r['account']!,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: ObsidianColors.titaniumLow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Amount Display & Quick Chips
                      Center(
                        child: Column(
                          children: [
                            Text(
                              ObsidianFormatters.currency(_amount),
                              style: ObsidianTypography.heroBalance.copyWith(
                                color: ObsidianColors.titaniumPure,
                                fontSize: 44,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Quick Amount Pills
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _quickAmounts.map((amt) {
                                final isSelected = _amount == amt;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _amount = amt),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? ObsidianColors.electricLime
                                            : ObsidianColors.glassFillHigh,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? ObsidianColors.electricLime
                                              : ObsidianColors.glassStroke,
                                        ),
                                      ),
                                      child: Text(
                                        '\$${amt.toInt()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: isSelected
                                              ? ObsidianColors.obsidianBase
                                              : ObsidianColors.titaniumMid,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Transfer Details Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ObsidianColors.glassFill,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ObsidianColors.glassStroke),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('From', 'Obsidian Checking •••• 4821'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1, color: ObsidianColors.glassStroke),
                            ),
                            _buildDetailRow('Fee', '\$0.00 (Instant Private Wire)', isHighlight: true),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1, color: ObsidianColors.glassStroke),
                            ),
                            _buildDetailRow('Arrival', 'Instant Execution'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Primary Interactive Action: Slide to Send
                      SlideToSend(onSlideComplete: _handleSend),
                      const SizedBox(height: 12),
                    ],
                  )
                else
                  // Success State with Celebratory Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ObsidianColors.electricLime.withValues(alpha: 0.15),
                              border: Border.all(color: ObsidianColors.electricLime, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: ObsidianColors.electricLime.withValues(alpha: 0.35),
                                  blurRadius: 24,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 44,
                              color: ObsidianColors.electricLime,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Transfer Complete',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: ObsidianColors.titaniumPure,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${ObsidianFormatters.currency(_amount)} sent to ${selectedRecipient['name']}',
                          style: ObsidianTypography.bodyRegular,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: ObsidianColors.electricLime.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: ObsidianColors.electricLime.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, size: 14, color: ObsidianColors.electricLime),
                              SizedBox(width: 6),
                              Text(
                                'Transaction Hash: 0x89d2...e482',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: ObsidianColors.electricLime,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          text: 'DONE',
                          width: double.infinity,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                // Particle Explosion on Success
                if (_isSuccess)
                  const Positioned.fill(
                    child: Center(
                      child: ParticleBurst(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: ObsidianTypography.bodyRegular.copyWith(fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isHighlight ? ObsidianColors.electricLime : ObsidianColors.titaniumHigh,
          ),
        ),
      ],
    );
  }
}
