import 'package:flutter/material.dart';
import '../../core/theme/obsidian_colors.dart';

/// The physical luxury Obsidian metal card (Front and Back).
class VirtualBankCard extends StatelessWidget {
  final bool showBack;
  final double glareOffsetX;
  final double glareOffsetY;
  final bool isFrozen;
  final String cardholderName;
  final String expiryDate;

  const VirtualBankCard({
    super.key,
    this.showBack = false,
    this.glareOffsetX = 0.0,
    this.glareOffsetY = 0.0,
    this.isFrozen = false,
    this.cardholderName = 'Alexander Wright',
    this.expiryDate = '11/29',
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.586, // Standard credit card ratio (85.60 × 53.98 mm)
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: ObsidianColors.electricLime.withValues(alpha: 0.08),
              blurRadius: 36,
              spreadRadius: -4,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.85),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Card Base Structure
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF262C3A),
                        Color(0xFF13161F),
                        Color(0xFF090A0E),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isFrozen ? Colors.cyan.withValues(alpha: 0.6) : ObsidianColors.glassStrokeHighlight,
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              // Subtle Brushed Metal Texture Lines
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardBrushedTexturePainter(),
                ),
              ),

              // Dynamic Specular Glare Reflection based on 3D Tilt
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardGlarePainter(
                    offsetX: glareOffsetX,
                    offsetY: glareOffsetY,
                    isFrozen: isFrozen,
                  ),
                ),
              ),

              // Front or Back Contents
              if (!showBack) _buildFront() else _buildBack(),

              // Frost Overlay when Card is Frozen
              if (isFrozen)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: ObsidianColors.obsidianBase.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.ac_unit_rounded, color: Colors.cyan, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'CARD FROZEN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Brand & Contactless Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [ObsidianColors.electricLime, Color(0xFF13161F)],
                        stops: [0.3, 1.0],
                      ),
                      border: Border.all(color: ObsidianColors.electricLime, width: 1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'OBSIDIAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                      color: ObsidianColors.titaniumPure,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.wifi_rounded, size: 20, color: ObsidianColors.titaniumMid),
                  SizedBox(width: 10),
                  Text(
                    'BLACK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: ObsidianColors.electricLime,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Middle: Luxury EMV Chip & VIP Badge
          Row(
            children: [
              _buildEmvChip(),
              const SizedBox(width: 14),
              // Subtle NFC Wave Lines
              Container(
                width: 32,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: ObsidianColors.titaniumLow.withValues(alpha: 0.4), width: 0.8),
                ),
                child: const Center(
                  child: Text(
                    'VIP',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: ObsidianColors.electricLime,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Area: Card Number, Name, Expiry, Logo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFrozen ? '•••• •••• •••• ••••' : '4929  8810  9412  3891',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.2,
                  fontFamily: 'monospace',
                  color: ObsidianColors.titaniumPure,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CARDHOLDER',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: ObsidianColors.titaniumLow,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cardholderName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: ObsidianColors.titaniumPure,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EXPIRES',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: ObsidianColors.titaniumLow,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isFrozen ? '••/••' : expiryDate,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          fontFamily: 'monospace',
                          color: ObsidianColors.titaniumPure,
                        ),
                      ),
                    ],
                  ),
                  // Luxury Holographic Dual Interlocking Circles
                  SizedBox(
                    width: 36,
                    height: 22,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ObsidianColors.electricLime.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ObsidianColors.electricViolet.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Magnetic Stripe
        Container(
          height: 44,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A0B0E), Color(0xFF141720), Color(0xFF0A0B0E)],
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Signature Strip & CVV
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFF232733),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Alexander Wright',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: ObsidianColors.titaniumMid,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 34,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D27),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: ObsidianColors.glassStroke),
                ),
                child: const Text(
                  '892',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: ObsidianColors.titaniumPure,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Back Disclaimer & Hologram
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Authorized by Obsidian Private Bank. Ultra-wealth tiered credit facility.\nVIP Concierge: +1 (800) 555-OBSD',
                  style: TextStyle(
                    fontSize: 8,
                    height: 1.4,
                    color: ObsidianColors.titaniumLow,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [ObsidianColors.electricLime, ObsidianColors.electricViolet],
                  ),
                ),
                child: const Icon(Icons.security_rounded, size: 16, color: ObsidianColors.obsidianBase),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmvChip() {
    return Container(
      width: 44,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE5C07B),
            Color(0xFFD19A66),
            Color(0xFF9E7B3B),
          ],
        ),
        border: Border.all(color: const Color(0xFFF3D38C), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5C07B).withValues(alpha: 0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ChipCircuitPainter(),
      ),
    );
  }
}

class _ChipCircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5C471E)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Horizontal dividers
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), paint);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.65), paint);

    // Center divider
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), paint);

    // Center rounded contact
    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.5),
      width: size.width * 0.32,
      height: size.height * 0.32,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardBrushedTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardGlarePainter extends CustomPainter {
  final double offsetX;
  final double offsetY;
  final bool isFrozen;

  _CardGlarePainter({
    required this.offsetX,
    required this.offsetY,
    required this.isFrozen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final highlightColor = isFrozen ? Colors.cyan : ObsidianColors.electricLime;

    final gradient = RadialGradient(
      center: Alignment(offsetX, offsetY),
      radius: 0.85,
      colors: [
        Colors.white.withValues(alpha: 0.16),
        highlightColor.withValues(alpha: 0.10),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.screen;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _CardGlarePainter oldDelegate) {
    return oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY ||
        oldDelegate.isFrozen != isFrozen;
  }
}
