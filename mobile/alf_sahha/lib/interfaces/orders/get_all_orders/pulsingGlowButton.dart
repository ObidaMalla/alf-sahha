import 'package:flutter/cupertino.dart';

import '../../../core/color/colors.dart';

class PulsingGlowButton extends StatefulWidget {
  final Widget child;

  const PulsingGlowButton({super.key, required this.child});

  @override
  State<PulsingGlowButton> createState() => _PulsingGlowButtonState();
}

class _PulsingGlowButtonState extends State<PulsingGlowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentColor.withOpacity(_animation.value),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
