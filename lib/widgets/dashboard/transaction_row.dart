import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';
import '../../core/utils/formatters.dart';

class TransactionItem {
  final String title;
  final String category;
  final String timestamp;
  final double amount;
  final IconData icon;
  final Color? iconColor;

  const TransactionItem({
    required this.title,
    required this.category,
    required this.timestamp,
    required this.amount,
    required this.icon,
    this.iconColor,
  });
}

/// Luxury transaction row with category badge, timestamp, and colored amount.
class TransactionRow extends StatelessWidget {
  final TransactionItem item;
  final VoidCallback? onTap;

  const TransactionRow({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = item.amount > 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: ObsidianColors.glassFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ObsidianColors.glassStroke, width: 0.8),
        ),
        child: Row(
          children: [
            // Category / Merchant Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ObsidianColors.obsidianElevated,
                border: Border.all(color: ObsidianColors.glassStroke),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: item.iconColor ?? ObsidianColors.titaniumHigh,
              ),
            ),
            const SizedBox(width: 14),

            // Title & Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ObsidianColors.titaniumPure,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.category} • ${item.timestamp}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ObsidianColors.titaniumLow,
                    ),
                  ),
                ],
              ),
            ),

            // Amount Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ObsidianFormatters.currency(item.amount, showSign: true),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: isIncome ? ObsidianColors.electricLime : ObsidianColors.titaniumPure,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isIncome ? 'Received' : 'Completed',
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
  }
}
