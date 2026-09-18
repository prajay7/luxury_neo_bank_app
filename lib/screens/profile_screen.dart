import 'package:flutter/material.dart';
import '../core/theme/obsidian_colors.dart';
import '../core/theme/obsidian_typography.dart';
import '../design_system/buttons.dart';
import '../design_system/glass_surface.dart';
import '../design_system/section_header.dart';
import '../design_system/snack_bar.dart';

/// Screen 4: Luxury Profile, Sovereign Tier Membership & VIP Concierge
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('VIP Sovereign', style: ObsidianTypography.screenTitle),
                  CircularIconButton(
                    icon: Icons.power_settings_new_rounded,
                    onPressed: () {
                      showObsidianSnackBar(
                        context,
                        'Obsidian biometric session remains encrypted and secured.',
                        icon: Icons.shield_rounded,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Luxury Tier Profile Card
              GlassSurface(
                borderRadius: 26,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2B3345), Color(0xFF141722)],
                            ),
                            border: Border.all(
                              color: ObsidianColors.electricLime,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ObsidianColors.electricLime.withValues(alpha: 0.25),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'AW',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: ObsidianColors.titaniumPure,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Alexander Wright',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: ObsidianColors.titaniumPure,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 16,
                                    color: ObsidianColors.electricLime,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Member #8942 • Tier Sovereign Black',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ObsidianColors.titaniumMid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: ObsidianColors.glassStroke),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('TIER STATUS', 'Sovereign', ObsidianColors.electricLime),
                        _buildStat('SECURITY', 'Quantum Safe', ObsidianColors.titaniumHigh),
                        _buildStat('ADVISOR', 'Active', ObsidianColors.cyanAccent),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Private Wealth Concierge
              const SectionHeader(title: 'Private Wealth Concierge'),
              GlassSurface(
                borderRadius: 24,
                borderColor: ObsidianColors.electricLime,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ObsidianColors.electricLime.withValues(alpha: 0.12),
                        border: Border.all(color: ObsidianColors.electricLime.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        color: ObsidianColors.electricLime,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Genevieve Laurent',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: ObsidianColors.titaniumPure,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Senior Wealth Officer • Geneva Desk',
                            style: TextStyle(fontSize: 12, color: ObsidianColors.titaniumMid),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      text: 'CALL',
                      height: 38,
                      onPressed: () {
                        showObsidianSnackBar(
                          context,
                          'Connecting to encrypted VIP satellite desk...',
                          icon: Icons.headset_mic_rounded,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Account & Security Options
              const SectionHeader(title: 'Security & Access'),
              _buildSettingItem(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric Secure Access',
                subtitle: 'FaceID + Hardware Key required for wires',
                trailing: const Icon(Icons.check_circle_rounded, color: ObsidianColors.electricLime, size: 20),
              ),
              const SizedBox(height: 10),
              _buildSettingItem(
                icon: Icons.vpn_key_rounded,
                title: 'Private Encryption Keys',
                subtitle: 'Manage local cryptographic seeds',
                trailing: const Icon(Icons.chevron_right_rounded, color: ObsidianColors.titaniumMid),
              ),
              const SizedBox(height: 10),
              _buildSettingItem(
                icon: Icons.account_balance_rounded,
                title: 'Linked Swiss & Vault Accounts',
                subtitle: '4 connected liquidity nodes',
                trailing: const Icon(Icons.chevron_right_rounded, color: ObsidianColors.titaniumMid),
              ),

              // Bottom padding to clear floating nav bar
              const SizedBox(height: 165),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: ObsidianTypography.labelCaps.copyWith(fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ObsidianColors.glassFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ObsidianColors.glassStroke, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ObsidianColors.obsidianElevated,
              border: Border.all(color: ObsidianColors.glassStroke),
            ),
            child: Icon(icon, size: 20, color: ObsidianColors.titaniumHigh),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ObsidianColors.titaniumPure,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: ObsidianColors.titaniumLow),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
