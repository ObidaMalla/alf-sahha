import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/redeemInviteCode/redeem_invite_code_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../models/redeemInviteCode/redeem_invite_code_model.dart';
import '../../mainScreen.dart';

class RedeemInviteCodeScreen extends StatefulWidget {
  const RedeemInviteCodeScreen({super.key});

  @override
  State<RedeemInviteCodeScreen> createState() => _RedeemInviteCodeScreenState();
}

class _RedeemInviteCodeScreenState extends State<RedeemInviteCodeScreen>
    with TickerProviderStateMixin {
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<_AnimatedSubmitButtonState> _buttonKey = GlobalKey();

  late final AnimationController _successAnimationController;
  late final AnimationController _beamController;
  late final AnimationController _inputBeamController;

  bool _isInputFocused = false;
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    _inputBeamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    _successAnimationController.dispose();
    _beamController.dispose();
    _inputBeamController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showStatusDialog({
    required bool success,
    required String message,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              content: AnimatedBuilder(
                animation: _beamController,
                builder: (context, child) {
                  return CustomPaint(
                    foregroundPainter: _BorderBeamPainter(
                      animationValue: _beamController.value,
                      colorA: success
                          ? AppColors.successColor
                          : const Color(0xFF8B0000),
                      colorB: success
                          ? Colors.tealAccent
                          : const Color(0xFFFF2400),
                      borderRadius: 20.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                success ? Icons.check_circle : Icons.error,
                                color: success
                                    ? AppColors.successColor
                                    : const Color(0xFF8B0000),
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                success ? 'نجاح' : 'خطأ',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              message,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'موافق',
                                style: TextStyle(
                                  color: AppColors.accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      RedeemInviteCodeCubit,
      ResultState<RedeemInviteCodeModel>
    >(
      listener: (context, state) {
        state.whenOrNull(
          success: (response) async {
            _successAnimationController.forward(from: 0.0);

            _showStatusDialog(
              success: true,
              message: response.message ?? 'تم الانضمام للمطعم بنجاح',
            );

            await Future.delayed(const Duration(seconds: 10));

            if (!mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false,
            );
          },
          error: (message) async {
            _buttonKey.currentState?.shakeAndFlash();
            await _showStatusDialog(success: false, message: message);
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'الانضمام لمطعم',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accentColor.withOpacity(.12),
                                ),
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: AppColors.accentColor,
                                  size: 46,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'أدخل كود الدعوة',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'إذا حصلت على كود دعوة من صاحب المطعم قم بإدخاله هنا للانضمام.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // خانة إدخال الكود مع شعاع متحرك عند التركيز ولون أحمر دامي
                        AnimatedBuilder(
                          animation: _inputBeamController,
                          builder: (context, child) {
                            return CustomPaint(
                              foregroundPainter: _isInputFocused
                                  ? _BorderBeamPainter(
                                      animationValue:
                                          _inputBeamController.value,
                                      colorA: AppColors.spicyColor,
                                      colorB: AppColors.accentColorDeep,
                                      borderRadius: 18.0,
                                    )
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.cardColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: TextFormField(
                                  controller: codeController,
                                  focusNode: _inputFocusNode,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  textCapitalization:
                                      TextCapitalization.characters,

                                  style: const TextStyle(
                                    color: Color(0xFF8B0000),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                    letterSpacing: 2,
                                  ),

                                  decoration: InputDecoration(
                                    hintText: 'أدخل كود الدعوة هنا',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),

                                    filled: true,
                                    fillColor: Colors.transparent,

                                    // لا إطار أبداً بالحالة العادية
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,

                                    // يظهر فقط عند الضغط
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                    ),

                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 22,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 25),
                        _AnimatedSubmitButton(
                          key: _buttonKey,
                          isLoading: isLoading,
                          label: 'الانضمام للمطعم',
                          retryLabel: 'إعادة كتابة الرمز',
                          onPressed: () {
                            final code = codeController.text.trim();

                            if (code.isEmpty) {
                              _showStatusDialog(
                                success: false,
                                message: 'أدخل كود الدعوة أولاً',
                              );
                              _buttonKey.currentState?.shakeAndFlash();
                              return;
                            }

                            context.read<RedeemInviteCodeCubit>().redeemCode(
                              code: code,
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.accentColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'بعد قبول الكود سيتم ربط حسابك بالمطعم مباشرة.',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _successAnimationController,
                  builder: (context, child) {
                    if (_successAnimationController.value == 0.0 ||
                        _successAnimationController.isDismissed) {
                      return const SizedBox.shrink();
                    }
                    return Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          color: AppColors.accentColor.withOpacity(
                            (1.0 - _successAnimationController.value) * 0.7,
                          ),
                          child: Center(
                            child: Transform.scale(
                              scale: Tween<double>(begin: 0.2, end: 2.5)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _successAnimationController,
                                      curve: Curves.elasticOut,
                                    ),
                                  )
                                  .value,
                              child: Opacity(
                                opacity: Tween<double>(begin: 1.0, end: 0.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _successAnimationController,
                                        curve: const Interval(
                                          0.6,
                                          1.0,
                                          curve: Curves.easeOut,
                                        ),
                                      ),
                                    )
                                    .value
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.9),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentColor,
                                        blurRadius: 50,
                                        spreadRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.accentColor,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSubmitButton extends StatefulWidget {
  final bool isLoading;
  final String label;
  final String retryLabel;
  final VoidCallback onPressed;

  const _AnimatedSubmitButton({
    super.key,
    required this.isLoading,
    required this.label,
    required this.retryLabel,
    required this.onPressed,
  });

  @override
  State<_AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<_AnimatedSubmitButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _buttonBeamController;
  late final Animation<double> _animOffset;
  bool _hasErrorState = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );
    _buttonBeamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    _animOffset = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonBeamController.dispose();
    super.dispose();
  }

  void shakeAndFlash() {
    setState(() {
      _hasErrorState = true;
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final currentLabel = _hasErrorState ? widget.retryLabel : widget.label;

    return AnimatedBuilder(
      animation: _animOffset,
      builder: (context, child) {
        final sinVal = math.sin(_animOffset.value * math.pi * 2);
        return Transform.translate(offset: Offset(sinVal * 6, 0), child: child);
      },
      child: AnimatedBuilder(
        animation: _buttonBeamController,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: _BorderBeamPainter(
              animationValue: _buttonBeamController.value,
              colorA: AppColors.spicyColor,
              colorB: AppColors.spicyColor,
              borderRadius: 18.0,
            ),
            child: child,
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // لون الزر شفاف
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_hasErrorState) {
                      setState(() {
                        _hasErrorState = false;
                      });
                    }
                    widget.onPressed();
                  },
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _hasErrorState
                            ? Icons.refresh_rounded
                            : Icons.login_rounded,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentLabel,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _BorderBeamPainter extends CustomPainter {
  final double animationValue;
  final Color colorA;
  final Color colorB;
  final double borderRadius;

  _BorderBeamPainter({
    required this.animationValue,
    required this.colorA,
    required this.colorB,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    final blended = Color.lerp(colorA, colorB, animationValue)!;

    canvas.drawPath(
      path,
      Paint()
        ..color = blended.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final metric = path.computeMetrics().first;
    final segmentLength = metric.length * 0.25;
    final start = metric.length * animationValue;
    final end = start + segmentLength;

    Path segment;
    if (end <= metric.length) {
      segment = metric.extractPath(start, end);
    } else {
      segment = metric.extractPath(start, metric.length);
      segment.addPath(metric.extractPath(0, end - metric.length), Offset.zero);
    }

    canvas.drawPath(
      segment,
      Paint()
        ..color = blended
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    canvas.drawPath(
      segment,
      Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
