import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/obsidian_colors.dart';

enum SlideStatus { idle, sliding, sending, sent }

/// Luxury interactive "SLIDE TO SEND" control.
class SlideToSend extends StatefulWidget {
  final Future<void> Function() onSlideComplete;
  final double height;

  const SlideToSend({
    super.key,
    required this.onSlideComplete,
    this.height = 64.0,
  });

  @override
  State<SlideToSend> createState() => _SlideToSendState();
}

class _SlideToSendState extends State<SlideToSend> with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  SlideStatus _status = SlideStatus.idle;

  late AnimationController _springController;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_status == SlideStatus.sending || _status == SlideStatus.sent) return;

    setState(() {
      _status = SlideStatus.sliding;
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double maxDrag) {
    if (_status == SlideStatus.sending || _status == SlideStatus.sent) return;

    if (_dragPosition >= maxDrag * 0.82) {
      // Trigger Send Sequence
      HapticFeedback.heavyImpact();
      setState(() {
        _dragPosition = maxDrag;
        _status = SlideStatus.sending;
      });

      widget.onSlideComplete().then((_) {
        if (mounted) {
          HapticFeedback.mediumImpact();
          setState(() {
            _status = SlideStatus.sent;
          });
        }
      });
    } else {
      // Snap back to origin
      _springAnimation = Tween<double>(begin: _dragPosition, end: 0.0).animate(
        CurvedAnimation(parent: _springController, curve: Curves.easeOutCubic),
      )..addListener(() {
          setState(() {
            _dragPosition = _springAnimation.value;
          });
        });

      _springController.forward(from: 0.0).then((_) {
        if (mounted) {
          setState(() {
            _status = SlideStatus.idle;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const thumbPadding = 5.0;
    final thumbSize = widget.height - (thumbPadding * 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - thumbSize - (thumbPadding * 2);
        final dragRatio = maxDrag > 0 ? (_dragPosition / maxDrag).clamp(0.0, 1.0) : 0.0;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: ObsidianColors.obsidianBase.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(widget.height * 0.5),
            border: Border.all(
              color: _status == SlideStatus.sent
                  ? ObsidianColors.gainGreen.withValues(alpha: 0.6)
                  : ObsidianColors.glassStrokeHighlight,
              width: 1.2,
            ),
            boxShadow: [
              if (_status == SlideStatus.sent)
                BoxShadow(
                  color: ObsidianColors.gainGreen.withValues(alpha: 0.3),
                  blurRadius: 20,
                )
              else if (dragRatio > 0.1)
                BoxShadow(
                  color: ObsidianColors.electricLime.withValues(alpha: 0.2 * dragRatio),
                  blurRadius: 16,
                ),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Sliding Progress Fill
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _dragPosition + thumbSize + (thumbPadding * 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: ObsidianColors.electricLime.withValues(alpha: 0.12 * dragRatio),
                    borderRadius: BorderRadius.circular(widget.height * 0.5),
                  ),
                ),
              ),

              // Center Label / State Text
              Center(
                child: Opacity(
                  opacity: (1.0 - (dragRatio * 1.5)).clamp(0.0, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_status == SlideStatus.sending) ...[
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ObsidianColors.electricLime,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'SENDING WIRE...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: ObsidianColors.electricLime,
                          ),
                        ),
                      ] else if (_status == SlideStatus.sent) ...[
                        const Icon(Icons.check_circle_rounded, color: ObsidianColors.gainGreen, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'TRANSFERRED',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: ObsidianColors.gainGreen,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'SLIDE TO SEND',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: ObsidianColors.titaniumMid,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: ObsidianColors.titaniumLow,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Draggable Thumb Button
              Positioned(
                left: thumbPadding + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => _onHorizontalDragUpdate(d, maxDrag),
                  onHorizontalDragEnd: (d) => _onHorizontalDragEnd(d, maxDrag),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _status == SlideStatus.sent
                          ? ObsidianColors.gainGreen
                          : ObsidianColors.electricLime,
                      boxShadow: [
                        BoxShadow(
                          color: (_status == SlideStatus.sent
                                  ? ObsidianColors.gainGreen
                                  : ObsidianColors.electricLime)
                              .withValues(alpha: 0.45),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _status == SlideStatus.sending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: ObsidianColors.obsidianBase,
                              ),
                            )
                          : Icon(
                              _status == SlideStatus.sent
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              color: ObsidianColors.obsidianBase,
                              size: 24,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
