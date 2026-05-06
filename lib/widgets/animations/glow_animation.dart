import 'package:flutter/material.dart';

class GlowAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color glowColor;

  const GlowAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.glowColor = Colors.orange,
  }) : super(key: key);

  @override
  State<GlowAnimation> createState() => _GlowAnimationState();
}

class _GlowAnimationState extends State<GlowAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);

    _blurAnimation = Tween<double>(begin: 5, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.glowColor.withOpacity(0.3),
      end: widget.glowColor.withOpacity(0.8),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _colorAnimation.value ?? widget.glowColor,
                blurRadius: _blurAnimation.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}