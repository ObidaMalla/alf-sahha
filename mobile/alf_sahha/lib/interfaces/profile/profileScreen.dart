import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/color/colors.dart';
import '../../cubits/logout/logout_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/results_state.dart';
import '../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../models/logout/logout_model.dart';
import '../../models/profile/profile_model.dart';
import '../login/loginScreen.dart';
import '../restaurant/redeemInviteCode/RedeemInviteCodeScreen.dart';
import '../wallet/wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final ProfileCubit _cubit;
  late final LogoutCubit _logoutCubit;
  late final AnimationController glowController;
  late final AnimationController _beamController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    _logoutCubit = getIt<LogoutCubit>();
    _cubit.getProfile();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();
  }

  @override
  void dispose() {
    _logoutCubit.close();
    glowController.dispose();
    _beamController.dispose();
    super.dispose();
  }

  String _roleLabel(String? role) {
    switch (role) {
      case 'OWNER':
        return 'صاحب مطعم 👑';
      case 'EMPLOYEE':
        return 'موظف 🍳';
      case 'CUSTOMER':
      default:
        return 'زبون  🙋️️';
    }
  }

  void _copyEmail(String email) {
    if (email.isEmpty) return;
    Clipboard.setData(ClipboardData(text: email));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ البريد الإلكتروني'),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openEditEmailSheet(String currentEmail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _EditEmailSheet(cubit: _cubit, initialEmail: currentEmail),
    ).then((updated) {
      if (updated == true) _cubit.getProfile();
    });
  }

  void _openChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangePasswordSheet(cubit: _cubit),
    ).then((updated) {
      if (updated == true) _cubit.getProfile();
    });
  }

  void _confirmLogout() {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: _logoutCubit,
        child: BlocConsumer<LogoutCubit, ResultState<LogoutModel>>(
          listener: (context, state) {
            state.whenOrNull(
              success: (response) async {
                await Future.delayed(const Duration(seconds: 3));

                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              error: (msg) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColors.errorColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            final isSuccess = state.maybeWhen(
              success: (_) => true,
              orElse: () => false,
            );

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: isSuccess
                        ? AppColors.successColor.withOpacity(0.4)
                        : Colors.redAccent.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.55),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSuccess
                            ? AppColors.successColor.withOpacity(0.15)
                            : Colors.redAccent.withOpacity(0.10),
                        border: Border.all(
                          color: isSuccess
                              ? AppColors.successColor.withOpacity(0.3)
                              : Colors.redAccent.withOpacity(0.20),
                        ),
                      ),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Colors.redAccent,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              isSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.logout_rounded,
                              color: isSuccess
                                  ? AppColors.successColor
                                  : Colors.redAccent,
                              size: isSuccess ? 34 : 29,
                            ),
                    ),
                    const SizedBox(height: 18),
                    TypewriterText(
                      text: isSuccess
                          ? 'تم تسجيل الخروج بنجاح'
                          : (isLoading
                                ? 'جاري تسجيل الخروج...'
                                : 'تسجيل الخروج'),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 9),
                    TypewriterText(
                      text: isSuccess
                          ? 'نراك قريباً! يتم توجيهك الآن...'
                          : (isLoading
                                ? 'يرجى الانتظار قليلاً...'
                                : 'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟'),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (!isLoading && !isSuccess)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: AppColors.borderColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () => _logoutCubit.logout(),
                                child: const Text(
                                  'خروج',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.group_add_rounded,
                color: AppColors.accentColor,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RedeemInviteCodeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ResultState<ProfileModel>>(
          bloc: _cubit,
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox.shrink(),
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
              error: (msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.errorColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(msg, style: TextStyle(color: AppColors.errorColor)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.getProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                      ),
                      child: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              success: (model) {
                final user = model.data;

                return RefreshIndicator(
                  color: AppColors.accentColor,
                  onRefresh: () async => _cubit.getProfile(),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildAvatarCard(user),
                      const SizedBox(height: 20),
                      _buildWalletCard(user?.walletBalance),
                      const SizedBox(height: 20),
                      _buildAccountSection(user),
                      const SizedBox(height: 20),
                      _buildLogoutButton(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // 1. كارد الملف الشخصي
  Widget _buildAvatarCard(ProfileData? user) {
    return AnimatedBuilder(
      animation: _beamController,
      builder: (_, child) {
        return CustomPaint(
          painter: _BorderBeamPainter(
            animationValue: _beamController.value,
            colorA: AppColors.accentColor,
            colorB: AppColors.goldColor,
            borderRadius: 24.0,
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.accentColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: AppColors.fireGradient),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _roleLabel(user?.role),
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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
      ),
    );
  }

  // 2. كارد المحفظة
  Widget _buildWalletCard(String? balance) {
    return AnimatedBuilder(
      animation: _beamController,
      builder: (_, child) {
        return CustomPaint(
          painter: _BorderBeamPainter(
            animationValue: _beamController.value,
            colorA: AppColors.accentColor,
            colorB: AppColors.goldColor,
            borderRadius: 22.0,
          ),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.accentColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.goldColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppColors.goldColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'رصيد المحفظة',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${balance ?? '0'} ل.س',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 3. كارد بيانات الحساب
  Widget _buildAccountSection(ProfileData? user) {
    return AnimatedBuilder(
      animation: _beamController,
      builder: (_, child) {
        return CustomPaint(
          painter: _BorderBeamPainter(
            animationValue: _beamController.value,
            colorA: AppColors.accentColor,
            colorB: AppColors.goldColor,
            borderRadius: 22.0,
          ),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.accentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: AppColors.accentColor,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Text(
                  'بيانات الحساب والأمان',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.alternate_email_rounded,
              label: 'البريد الإلكتروني',
              value: user?.email ?? '',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => _copyEmail(user?.email ?? ''),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                  _chip(
                    'تغيير',
                    AppColors.accentColor,
                    () => _openEditEmailSheet(user?.email ?? ''),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.borderColor, height: 24),
            _buildInfoRow(
              icon: Icons.lock_outline_rounded,
              label: 'كلمة المرور',
              value: '••••••••••',
              trailing: _chip(
                'تغيير',
                AppColors.goldColor,
                _openChangePasswordSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. زر تسجيل الخروج مع الشعاع المتحرك (Border Beam) وخلفية شفافة
  Widget _buildLogoutButton() {
    return AnimatedBuilder(
      animation: _beamController,
      builder: (_, child) {
        return CustomPaint(
          painter: _BorderBeamPainter(
            animationValue: _beamController.value,
            colorA: Colors.redAccent,
            colorB: Colors.orangeAccent,
            borderRadius: 18.0,
          ),
          child: child,
        );
      },
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // خلفية شفافة
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
            ),
          ),
          onPressed: _confirmLogout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}

// ---------------------------------------------------------
// ويدجت مساعدة لعمل تأثير الكتابة (Typewriter Effect)
// ---------------------------------------------------------
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _currentIndex = 0;
      _displayedText = '';
      _startTyping();
    }
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

class _EditEmailSheet extends StatefulWidget {
  final ProfileCubit cubit;
  final String initialEmail;

  const _EditEmailSheet({required this.cubit, required this.initialEmail});

  @override
  State<_EditEmailSheet> createState() => _EditEmailSheetState();
}

class _EditEmailSheetState extends State<_EditEmailSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitted = true);

    widget.cubit.updateProfile(
      email: _emailController.text.trim(),
      currentPassword: _passwordController.text,
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 13.5),
      prefixIcon: Icon(icon, color: AppColors.accentColor, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.backgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
        borderSide: BorderSide(color: AppColors.accentColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ResultState<ProfileModel>>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (!_submitted) return;

        state.whenOrNull(
          success: (model) {
            _submitted = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم تحديث البيانات بنجاح'),
                backgroundColor: AppColors.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pop(context, true);
          },
          error: (msg) {
            _submitted = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading =
            _submitted &&
            state.maybeWhen(loading: () => true, orElse: () => false);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.cardColor, AppColors.backgroundSecondary],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.accentColor.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.12),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // مقبض السحب
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: AppColors.borderColorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Header بالأيقونة
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: AppColors.fireGradient,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentColor.withOpacity(0.35),
                              blurRadius: 14,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.alternate_email_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تعديل البريد الإلكتروني',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'أدخل الإيميل الجديد وكلمة المرور للتأكيد',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'الإيميل الجديد',
                      icon: Icons.alternate_email_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'كلمة المرور الحالية',
                      icon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الحالية';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.fireGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentColor.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: isLoading ? null : _submit,
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'حفظ التعديل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
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
      },
    );
  }
} // ---------------------------------------------------------

// شاشة تغيير كلمة المرور
// ---------------------------------------------------------

class _ChangePasswordSheet extends StatefulWidget {
  final ProfileCubit cubit;

  const _ChangePasswordSheet({required this.cubit});

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _submitted = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitted = true);

    widget.cubit.updateProfile(
      newPassword: _newPasswordController.text,
      currentPassword: _currentPasswordController.text,
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 13.5),
      prefixIcon: Icon(icon, color: AppColors.goldColor, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: onToggle,
      ),
      filled: true,
      fillColor: AppColors.backgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
        borderSide: BorderSide(color: AppColors.goldColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.errorColor, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ResultState<ProfileModel>>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (!_submitted) return;

        state.whenOrNull(
          success: (model) {
            _submitted = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم تحديث البيانات بنجاح'),
                backgroundColor: AppColors.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pop(context, true);
          },
          error: (msg) {
            _submitted = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isLoading =
            _submitted &&
            state.maybeWhen(loading: () => true, orElse: () => false);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.cardColor, AppColors.backgroundSecondary],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.goldColor.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldColor.withOpacity(0.10),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: AppColors.borderColorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: AppColors.goldGradient,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.goldColor.withOpacity(0.35),
                              blurRadius: 14,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تغيير كلمة المرور',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'اختر كلمة مرور جديدة وقوية لحسابك',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'كلمة المرور الحالية',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscureCurrent,
                      onToggle: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الحالية';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'كلمة المرور الجديدة',
                      icon: Icons.lock_rounded,
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الجديدة';
                      }
                      if (value.length < 6) {
                        return 'يجب ألا تقل عن 6 أحرف';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: _fieldDecoration(
                      hint: 'تأكيد كلمة المرور الجديدة',
                      icon: Icons.check_circle_outline_rounded,
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.goldGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldColor.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: isLoading ? null : _submit,
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black87,
                                    ),
                                  )
                                : const Text(
                                    'حفظ كلمة المرور الجديدة',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
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
      },
    );
  }
}

// ---------------------------------------------------------
// رسام الشعاع المتحرك على الإطار (Border Beam Painter)
// ---------------------------------------------------------
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
        ..color = Colors.white.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap,
    );
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
