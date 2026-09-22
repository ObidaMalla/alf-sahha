import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/restaurantCubit/create_restaurant_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/restaurant/create_restaurant_model.dart';

class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({super.key});

  @override
  State<CreateRestaurantScreen> createState() => _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  late final CreateRestaurantCubit _cubit;
  late final AnimationController _glowController;

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _loadingDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CreateRestaurantCubit>();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _addressController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _glowController.dispose();
    _cubit.close();
    super.dispose();
  }

  // =========================================================
  // نسبة إكمال الفورم — لغرض المؤشر البصري فقط
  // =========================================================
  double get _completionRatio {
    int filled = 0;
    const total = 4; // اسم + وصف + عنوان + صورة
    if (_nameController.text.trim().isNotEmpty) filled++;
    if (_descriptionController.text.trim().isNotEmpty) filled++;
    if (_addressController.text.trim().isNotEmpty) filled++;
    if (_selectedImage != null) filled++;
    return filled / total;
  }

  // =========================================================
  // اختيار صورة من المعرض
  // =========================================================
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1600,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (_) {
      if (!mounted) return;

      _showResultDialog(
        success: false,
        title: 'تعذر اختيار الصورة',
        message: 'حدث خطأ أثناء اختيار الصورة، حاول مرة أخرى.',
      );
    }
  }

  // =========================================================
  // إرسال البيانات
  // =========================================================
  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _cubit.createRestaurant(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      image: _selectedImage,
    );
  }

  // =========================================================
  // Loading Dialog
  // =========================================================
  void _showLoadingDialog() {
    if (_loadingDialogVisible) return;
    _loadingDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.72),
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 45),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.accentColor.withOpacity(.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.50),
                    blurRadius: 35,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: AppColors.accentColor,
                      backgroundColor: AppColors.accentColor.withOpacity(.12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'جاري إنشاء المطعم',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'لحظات قليلة...',
                    style: TextStyle(color: AppColors.hintColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _loadingDialogVisible = false;
    });
  }

  void _hideLoadingDialog() {
    if (!_loadingDialogVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
    _loadingDialogVisible = false;
  }

  // =========================================================
  // Success / Error Dialog
  // =========================================================
  Future<void> _showResultDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.75),
      builder: (dialogContext) {
        final statusColor = success
            ? AppColors.successColor
            : AppColors.errorColor;
        final statusIcon = success ? Icons.check_rounded : Icons.close_rounded;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 390),
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 22),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: statusColor.withOpacity(.30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.55),
                    blurRadius: 40,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withOpacity(.12),
                      border: Border.all(
                        color: statusColor.withOpacity(.45),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(.18),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 45),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 14,
                      height: 1.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.fireGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          success ? 'متابعة' : 'حسناً',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
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

  // =========================================================
  // Decorations
  // =========================================================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.hintColor.withOpacity(.70),
        fontSize: 13.5,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Icon(icon, color: AppColors.accentColor, size: 21),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      filled: true,
      fillColor: AppColors.inputColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: Colors.white.withOpacity(.07)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.accentColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.errorColor.withOpacity(.8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide(color: AppColors.errorColor, width: 1.4),
      ),
    );
  }

  // =========================================================
  // Build
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return BlocListener<
      CreateRestaurantCubit,
      ResultState<CreateRestaurantModel>
    >(
      bloc: _cubit,
      listener: (context, state) {
        state.whenOrNull(
          loading: () => _showLoadingDialog(),
          success: (response) async {
            _hideLoadingDialog();
            await Future.delayed(const Duration(milliseconds: 150));
            if (!mounted) return;

            await _showResultDialog(
              success: true,
              title: 'تم إنشاء المطعم',
              message:
                  response.message ??
                  'تم إنشاء مطعمك بنجاح وأصبح حسابك جاهزاً.',
            );

            if (!mounted) return;

            Navigator.of(
              context,
            ).pop(true); // 👈 يرجع لـ MainScreen الموجودة أصلاً
          },
          error: (message) async {
            _hideLoadingDialog();
            await Future.delayed(const Duration(milliseconds: 150));
            if (!mounted) return;

            await _showResultDialog(
              success: false,
              title: 'تعذر إنشاء المطعم',
              message: message,
            );
          },
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              // ===== توهجات خلفية زخرفية =====
              Positioned(
                top: -120,
                right: -100,
                child: _glowBlob(AppColors.accentColor, 280),
              ),
              Positioned(
                bottom: -100,
                left: -90,
                child: _glowBlob(AppColors.goldColor, 220),
              ),

              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),
                    _buildProgressBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeroHeader(),
                              const SizedBox(height: 30),
                              _buildSectionCard(
                                title: 'المعلومات الأساسية',
                                icon: Icons.badge_outlined,
                                children: [
                                  _buildLabel('اسم المطعم', required: true),
                                  const SizedBox(height: 9),
                                  TextFormField(
                                    controller: _nameController,
                                    cursorColor: AppColors.accentColor,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'اسم المطعم مطلوب';
                                      }
                                      return null;
                                    },
                                    decoration: _inputDecoration(
                                      hint: 'مثال: مطعم الأصالة',
                                      icon: Icons.storefront_outlined,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildLabel('الوصف'),
                                  const SizedBox(height: 9),
                                  TextFormField(
                                    controller: _descriptionController,
                                    cursorColor: AppColors.accentColor,
                                    maxLines: 4,
                                    minLines: 3,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                    ),
                                    decoration: _inputDecoration(
                                      hint:
                                          'اكتب وصفاً بسيطاً عن مطعمك وما يميزه...',
                                      icon: Icons.notes_rounded,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildLabel('العنوان'),
                                  const SizedBox(height: 9),
                                  TextFormField(
                                    controller: _addressController,
                                    cursorColor: AppColors.accentColor,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                    ),
                                    decoration: _inputDecoration(
                                      hint: 'مثال: دمشق - المزة',
                                      icon: Icons.location_on_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              _buildSectionCard(
                                title: 'صورة المطعم',
                                icon: Icons.image_outlined,
                                children: [_buildImagePicker()],
                              ),
                              const SizedBox(height: 30),
                              _buildSubmitButton(),
                              const SizedBox(height: 16),
                              _buildNote(),
                            ],
                          ),
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
    );
  }

  // =========================================================
  // شريط علوي
  // =========================================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.inputColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.06)),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'إنشاء مطعم',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 43),
        ],
      ),
    );
  }

  // =========================================================
  // شريط تقدّم إكمال الفورم
  // =========================================================
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اكتمال البيانات',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(_completionRatio * 100).round()}%',
                style: TextStyle(
                  color: AppColors.goldColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _completionRatio),
              duration: const Duration(milliseconds: 350),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: AppColors.inputColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ترويسة كبيرة بمتحرك توهج ذهبي حول الأيقونة
  // =========================================================
  Widget _buildHeroHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return CustomPaint(
              painter: _RingBeamPainter(
                animationValue: _glowController.value,
                color: AppColors.goldColor,
              ),
              child: child,
            );
          },
          child: Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.fireGradient,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentColor.withOpacity(.25),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'أنشئ مطعمك الخاص',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'أدخل معلومات المطعم الأساسية للبدء',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.hintColor, fontSize: 13.5),
        ),
      ],
    );
  }

  // =========================================================
  // كارت قسم موحّد
  // =========================================================
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentColorSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.accentColor, size: 17),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  // =========================================================
  // زر الإرسال
  // =========================================================
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.fireGradient),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentColor.withValues(alpha: .27),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_business_rounded, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                'إنشاء المطعم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ملاحظة سفلية
  // =========================================================
  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.accentColor.withOpacity(.055),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentColor.withOpacity(.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.accentColor.withOpacity(.8),
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'بعد إنشاء المطعم سيتم تحديث صلاحية حسابك تلقائياً.',
              style: TextStyle(
                color: AppColors.hintColor,
                fontSize: 12.5,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // توهج خلفي دائري زخرفي
  // =========================================================
  Widget _glowBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.10),
            blurRadius: 110,
            spreadRadius: 25,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // منتقي الصورة
  // =========================================================
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 190,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.inputColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedImage != null
                ? AppColors.goldColor.withOpacity(.55)
                : Colors.white.withOpacity(.07),
            width: _selectedImage != null ? 1.4 : 1,
          ),
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.goldColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.goldColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'إضافة صورة للمطعم',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'اضغط لاختيار صورة من المعرض',
                    style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_selectedImage!, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.68),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldColor.withOpacity(.92),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: AppColors.backgroundColor,
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'تغيير الصورة',
                            style: TextStyle(
                              color: AppColors.backgroundColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLabel(String title, {bool required = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: AppColors.errorColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ] else ...[
          const SizedBox(width: 6),
          Text(
            'اختياري',
            style: TextStyle(
              color: AppColors.hintColor.withOpacity(.65),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// 🌟 حلقة توهج ذهبية تدور حول أيقونة الترويسة
// ============================================================
class _RingBeamPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _RingBeamPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    const int particleCount = 24;
    for (int i = 0; i < particleCount; i++) {
      final double progressOffset = i / particleCount;
      final double angle =
          (animationValue * 2 * 3.14159) - (i * 2 * 3.14159 / particleCount);
      final double opacity = (1.0 - progressOffset) * 0.9;

      final dx = center.dx + radius * cosApprox(angle);
      final dy = center.dy + radius * sinApprox(angle);

      canvas.drawCircle(
        Offset(dx, dy),
        i == 0 ? 3.0 : 1.6,
        Paint()
          ..color = color.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, i == 0 ? 3.0 : 1.0),
      );
    }
  }

  double cosApprox(double angle) => _cos(angle);
  double sinApprox(double angle) => _sin(angle);

  double _cos(double x) => math.cos(x);
  double _sin(double x) => math.sin(x);

  @override
  bool shouldRepaint(covariant _RingBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color;
  }
}
