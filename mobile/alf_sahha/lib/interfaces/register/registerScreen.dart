import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/color/colors.dart';
import '../../cubits/registerCubit/register_cubit.dart';
import '../../cubits/results_state.dart';
import '../../injections/bootStrap/auth/_register/register_injection.dart';
import '../../models/register/register_model.dart';
import '../login/loginScreen.dart'; // 👈 عدّل الاسم/المسار حسب ملف تسجيل الدخول الفعلي عندك

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  late final RegisterCubit _cubit; // 👈 مباشرة من GetIt، بلا BlocProvider

  late final AnimationController _beamController;
  late final AnimationController _glowController;
  final GlobalKey<_AnimatedSubmitButtonState> _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RegisterCubit>();

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _beamController.dispose();
    _glowController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegister(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _buttonKey.currentState?.shakeAndFlash();
      return;
    }
    _cubit.registerUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _showFloatingSnackBar(String message, {required bool isSuccess}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isSuccess
              ? AppColors.successColor
              : AppColors.dangerColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 15),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 24),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.inputColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<RegisterCubit, ResultState<RegisterModel>>(
          bloc: _cubit, // 👈 بلا BlocProvider، بنمرر الـ cubit مباشرة
          listener: (context, state) {
            state.whenOrNull(
              success: (response) async {
                if (response.success != true) {
                  _showFloatingSnackBar(
                    response.message ?? 'فشلت عملية إنشاء الحساب',
                    isSuccess: false,
                  );
                  _buttonKey.currentState?.shakeAndFlash();
                  return;
                }

                _showFloatingSnackBar(
                  response.message ?? 'تم إنشاء الحساب بنجاح 🚀',
                  isSuccess: true,
                );

                // الانتظار لمدة 3 ثوانٍ
                await Future.delayed(const Duration(seconds: 3));

                if (!mounted) return;

                // الانتقال لشاشة تسجيل الدخول وحذف الشاشات السابقة
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              error: (error) {
                debugPrint('❌ [RegisterScreen] $error');
                _showFloatingSnackBar(error, isSuccess: false);
                _buttonKey.currentState?.shakeAndFlash();
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );
            return Stack(
              children: [
                // 🔥 خلفية متوهجة (نار + ذهب) خافتة تتحرك ببطء
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final t = _glowController.value;
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(0, -0.7),
                                radius: 1.3,
                                colors: [
                                  AppColors.accentColor.withOpacity(
                                    0.10 + 0.04 * t,
                                  ),
                                  AppColors.backgroundColor,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          left: -40,
                          child: _GlowOrb(
                            color: AppColors.goldColor,
                            size: 220,
                            opacity: 0.10 + 0.05 * (1 - t),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SafeArea(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),

                          // 🔥 LOGO — دائرة نارية متوهجة
                          AnimatedBuilder(
                            animation: _glowController,
                            builder: (context, child) {
                              final glow = 0.5 + (_glowController.value * 0.5);
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.cardColor,
                                  border: Border.all(
                                    color: AppColors.accentColor.withOpacity(
                                      0.4,
                                    ),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentColor.withOpacity(
                                        0.28 * glow,
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: AppColors.fireGradient,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentColor
                                            .withOpacity(0.4 * glow),
                                        blurRadius: 20,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_rounded,
                                    color: Colors.white,
                                    size: 46,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 22),

                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: AppColors.fireGradient,
                            ).createShader(bounds),
                            child: const Text(
                              'إنشاء حساب جديد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'انضم إلينا واستمتع بأشهى الأطباق 🍽️',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 🃏 REGISTER CARD مع حدود متحركة (Border Beam)
                          AnimatedBuilder(
                            animation: _beamController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _BorderBeamPainter(
                                  animationValue: _beamController.value,
                                  colorA: AppColors.accentColor,
                                  colorB: AppColors.goldColor,
                                  borderRadius: 28.0,
                                ),
                                child: child,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: AppColors.darkGlassGradient,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 26,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildFieldLabel('الاسم الكامل'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _nameController,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                      cursorColor: AppColors.accentColor,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'يرجى إدخال الاسم الكامل';
                                        }
                                        return null;
                                      },
                                      decoration: _inputDecoration(
                                        hint: 'أدخل اسمك الكامل',
                                        icon: Icons.person_outline_rounded,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    _buildFieldLabel('البريد الإلكتروني'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                      cursorColor: AppColors.accentColor,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'يرجى إدخال البريد الإلكتروني';
                                        }
                                        if (!RegExp(
                                          r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                                        ).hasMatch(value.trim())) {
                                          return 'يرجى إدخال بريد إلكتروني صالح';
                                        }
                                        return null;
                                      },
                                      decoration: _inputDecoration(
                                        hint: 'أدخل بريدك الإلكتروني',
                                        icon: Icons.email_outlined,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    _buildFieldLabel('كلمة المرور'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _isPasswordObscured,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) {
                                        if (!isLoading)
                                          _submitRegister(context);
                                      },
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                      cursorColor: AppColors.accentColor,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'يرجى إدخال كلمة المرور';
                                        }
                                        if (value.length < 6) {
                                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                        }
                                        return null;
                                      },
                                      decoration: _inputDecoration(
                                        hint: 'أدخل كلمة المرور',
                                        icon: Icons.lock_outline_rounded,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordObscured =
                                                  !_isPasswordObscured;
                                            });
                                          },
                                          icon: Icon(
                                            _isPasswordObscured
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.textSecondary,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    _AnimatedSubmitButton(
                                      key: _buttonKey,
                                      isLoading: isLoading,
                                      label: 'إنشاء حساب',
                                      onPressed: () => _submitRegister(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لديك حساب بالفعل؟ ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: AppColors.fireGradient,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'FLAVOR HOUSE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.footerColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ============================================================
// 🔘 زر الإرسال — بتدرج ناري + اهتزاز عند الخطأ
// ============================================================
class _AnimatedSubmitButton extends StatefulWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  const _AnimatedSubmitButton({
    super.key,
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<_AnimatedSubmitButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animOffset = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shakeAndFlash() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animOffset,
      builder: (context, child) {
        final sinVal = math.sin(_animOffset.value * math.pi * 2);
        return Transform.translate(offset: Offset(sinVal * 6, 0), child: child);
      },
      child: SizedBox(
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: AppColors.fireGradient),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentColor.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 🌟 توهج خلفي زخرفي
// ============================================================
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity),
              blurRadius: 90,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 🔥✨ حدود متحركة بلونين (نار + ذهب) تدور بلا توقف حول الكارت
// ============================================================
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

    // إطار خافت ثابت
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
