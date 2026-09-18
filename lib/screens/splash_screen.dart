import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/obsidian_colors.dart';
import 'main_navigation_shell.dart';

/// Cinematic Luxury Splash Screen for Obsidian Wealth
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _subtextFadeAnimation;

  String _statusText = 'ENCRYPTED SESSION INITIALIZING';
  Timer? _statusTimer1;
  Timer? _statusTimer2;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    // Main entrance animations
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Continuous ambient breathing pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );

    _subtextFadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _mainController.forward();
    _progressController.forward();

    // High-tech status message transitions
    _statusTimer1 = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _statusText = 'ESTABLISHING QUANTUM CIPHER...';
        });
      }
    });

    _statusTimer2 = Timer(const Duration(milliseconds: 1900), () {
      if (mounted) {
        setState(() {
          _statusText = 'BIOMETRIC HANDSHAKE VERIFIED';
        });
      }
    });

    // Auto navigate to main app
    _navTimer = Timer(const Duration(milliseconds: 3000), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _statusTimer1?.cancel();
    _statusTimer2?.cancel();
    _navTimer?.cancel();
    _mainController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ObsidianColors.obsidianBase,
      body: Stack(
        children: [
          // Ambient Radial Gradient Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final pulse = _pulseController.value;
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.15),
                      radius: 1.1 + (pulse * 0.15),
                      colors: [
                        ObsidianColors.electricLime.withValues(alpha: 0.08 + (pulse * 0.04)),
                        ObsidianColors.electricViolet.withValues(alpha: 0.06 + (pulse * 0.03)),
                        const Color(0xFF0C0E14),
                        ObsidianColors.obsidianBase,
                      ],
                      stops: const [0.0, 0.35, 0.7, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Subtle Geometric Grid Lines Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _LuxuryGridPainter(),
            ),
          ),

          // Central Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Official Stitch Obsidian Wealth Logo with Ambient Glow Halo
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final pulse = _pulseController.value;
                          return Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(44),
                              boxShadow: [
                                BoxShadow(
                                  color: ObsidianColors.electricLime.withValues(alpha: 0.28 + (pulse * 0.16)),
                                  blurRadius: 46 + (pulse * 20),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: ObsidianColors.electricViolet.withValues(alpha: 0.18 + (pulse * 0.1)),
                                  blurRadius: 65,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(44),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/icons/app_icon.png',
                                    fit: BoxFit.cover,
                                    width: 210,
                                    height: 210,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFF131620),
                                        child: const Center(
                                          child: Icon(
                                            Icons.diamond_outlined,
                                            size: 72,
                                            color: ObsidianColors.electricLime,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Subtle glass specular reflection rim
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(44),
                                      border: Border.all(
                                        color: ObsidianColors.glassStrokeHighlight.withValues(alpha: 0.6),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Brand Tagline
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: const Text(
                      'PRIVATE WEALTH • SOVEREIGN ASSETS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.5,
                        color: ObsidianColors.titaniumLow,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Security Loading Bar & Cipher Status
                  FadeTransition(
                    opacity: _subtextFadeAnimation,
                    child: Column(
                      children: [
                        // Progress Bar Container
                        Container(
                          width: size.width * 0.55,
                          height: 3,
                          decoration: BoxDecoration(
                            color: ObsidianColors.obsidianElevated,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressController.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        ObsidianColors.electricViolet,
                                        ObsidianColors.electricLime,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ObsidianColors.electricLime.withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Animated Status Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ObsidianColors.electricLime,
                                boxShadow: [
                                  BoxShadow(
                                    color: ObsidianColors.electricLime,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _statusText,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.6,
                                color: ObsidianColors.titaniumMid,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Skip / Enter Button
                        GestureDetector(
                          onTap: _navigateToHome,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              'TAP TO ENTER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: ObsidianColors.titaniumLow.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom luxury grid painter for subtle high-tech backdrop
class _LuxuryGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
