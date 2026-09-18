import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'virtual_bank_card.dart';

/// 3D Interactive Card View that tilts on pan gestures and flips on tap.
class CardTiltView extends StatefulWidget {
  final bool isFrozen;
  final VoidCallback? onFlipChanged;

  const CardTiltView({
    super.key,
    this.isFrozen = false,
    this.onFlipChanged,
  });

  @override
  State<CardTiltView> createState() => CardTiltViewState();
}

class CardTiltViewState extends State<CardTiltView> with TickerProviderStateMixin {
  // 3D Tilt offsets
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  // Spring animation controller for releasing drag
  late AnimationController _springController;
  late Animation<double> _springAnimationX;
  late Animation<double> _springAnimationY;

  // Flip animation controller
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isBack = false;

  bool get isBack => _isBack;

  @override
  void initState() {
    super.initState();

    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        setState(() {
          _tiltX = _springAnimationX.value;
          _tiltY = _springAnimationY.value;
        });
      });

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _springController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  /// Flip card between front and back
  void flipCard() {
    if (_flipController.isAnimating) return;
    if (_isBack) {
      _flipController.reverse();
      _isBack = false;
    } else {
      _flipController.forward();
      _isBack = true;
    }
    widget.onFlipChanged?.call();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    _springController.stop();
    setState(() {
      // Normalize tilt between -0.4 and 0.4 radians
      _tiltY += details.delta.dx / (size.width * 0.5);
      _tiltX -= details.delta.dy / (size.height * 0.5);

      _tiltX = _tiltX.clamp(-0.35, 0.35);
      _tiltY = _tiltY.clamp(-0.35, 0.35);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _springAnimationX = Tween<double>(begin: _tiltX, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );
    _springAnimationY = Tween<double>(begin: _tiltY, end: 0.0).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    );
    _springController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, constraints.maxWidth / 1.586);

        return GestureDetector(
          onPanUpdate: (details) => _onPanUpdate(details, cardSize),
          onPanEnd: _onPanEnd,
          onTap: flipCard,
          behavior: HitTestBehavior.opaque,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012) // Perspective depth
              ..rotateX(_tiltX)
              ..rotateY(_tiltY + (_flipAnimation.value * math.pi)),
            child: _flipAnimation.value >= 0.5
                // Render back of card (mirrored so text is right-side up)
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: VirtualBankCard(
                      showBack: true,
                      glareOffsetX: -_tiltY * 2,
                      glareOffsetY: _tiltX * 2,
                      isFrozen: widget.isFrozen,
                    ),
                  )
                // Render front of card
                : VirtualBankCard(
                    showBack: false,
                    glareOffsetX: _tiltY * 2,
                    glareOffsetY: -_tiltX * 2,
                    isFrozen: widget.isFrozen,
                  ),
          ),
        );
      },
    );
  }
}
