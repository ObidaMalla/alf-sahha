import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/results_state.dart';
import '../../../models/menu_item/menu_item_model.dart';
import '../../cubits/menu_items/menu_itemsCubit/menu_items_cubit.dart';

class AddMenuItemScreen extends StatefulWidget {
  final String restaurantId;
  final Function(int)? onNavigateToTab; // دالة التنقل بين التبويبات

  const AddMenuItemScreen({
    super.key,
    required this.restaurantId,
    this.onNavigateToTab,
  });

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String selectedCategory = 'FOOD'; // القيمة الافتراضية للتصنيف
  File? selectedImage;

  final GlobalKey<_AnimatedSubmitButtonState> _buttonKey = GlobalKey();

  late final AnimationController _successAnimationController;
  late final AnimationController _beamController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.2, end: 2.5).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    _successAnimationController.dispose();
    _beamController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
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
                      colorA: success ? AppColors.successColor : Colors.red,
                      colorB: success ? Colors.tealAccent : Colors.orangeAccent,
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
                                    : Colors.red,
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
    return BlocConsumer<MenuItemCubit, ResultState<MenuItemModel>>(
      listener: (context, state) {
        state.whenOrNull(
          success: (response) async {
            _successAnimationController.forward(from: 0.0);

            _showStatusDialog(
              success: true,
              message: response.message ?? '👌تم إضافة الصنف بنجاح',
            );

            await Future.delayed(const Duration(seconds: 1));

            if (!mounted) return;

            // 1. إغلاق الـ Dialog المنبثق
            Navigator.of(context, rootNavigator: true).pop();

            // 2. تفريغ الحقول وإعادة تعيين الصورة لتبدو الشاشة نظيفة للمرة القادمة
            nameController.clear();
            descriptionController.clear();
            priceController.clear();
            setState(() {
              selectedImage = null;
              selectedCategory = 'FOOD';
            });

            // 3. الانتقال للتاب رقم 0 (الرئيسية) بسلاسة من خلال الـ MainScreen
            if (widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(0);
            }
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
                'إضافة صنف جديد',
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
                        // اختيار الصورة
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1.5,
                              ),
                              image: selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_rounded,
                                        color: AppColors.accentColor,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'إضافة صورة الصنف',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // اسم الصنف
                        _buildTextField(
                          controller: nameController,
                          hintText: 'اسم الصنف (مثال: شاورما دجاج)',
                          icon: Icons.fastfood_rounded,
                        ),
                        const SizedBox(height: 16),

                        // وصف الصنف
                        _buildTextField(
                          controller: descriptionController,
                          hintText: 'وصف الصنف والمكونات',
                          icon: Icons.description_rounded,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // السعر
                        _buildTextField(
                          controller: priceController,
                          hintText: 'السعر (مثال: 50)',
                          icon: Icons.attach_money_rounded,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // اختيار التصنيف (Category Dropdown)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.inputColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              dropdownColor: AppColors.cardColor,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.accentColor,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'FOOD',
                                  child: Text(
                                    'طعام (FOOD)',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'DRINK',
                                  child: Text(
                                    'مشروبات (DRINK)',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'DESSERT',
                                  child: Text(
                                    'حلويات (DESSERT)',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // زر الإرسال
                        _AnimatedSubmitButton(
                          key: _buttonKey,
                          isLoading: isLoading,
                          label: 'إضافة الصنف',
                          retryLabel: 'إعادة المحاولة',
                          onPressed: () {
                            final name = nameController.text.trim();
                            final description = descriptionController.text
                                .trim();
                            final price = priceController.text.trim();

                            if (name.isEmpty || price.isEmpty) {
                              _showStatusDialog(
                                success: false,
                                message:
                                    'يرجى إدخال اسم الصنف والسعر على الأقل',
                              );
                              _buttonKey.currentState?.shakeAndFlash();
                              return;
                            }

                            context.read<MenuItemCubit>().addMenuItem(
                              restaurantId: widget.restaurantId,
                              name: name,
                              description: description.isEmpty
                                  ? null
                                  : description,
                              price: price,
                              category: selectedCategory,
                              image: selectedImage,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // أنيميشن النجاح
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
                              scale: _scaleAnimation.value,
                              child: Opacity(
                                opacity: _opacityAnimation.value.clamp(
                                  0.0,
                                  1.0,
                                ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.accentColor),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
        filled: true,
        fillColor: AppColors.inputColor,
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
          borderSide: BorderSide(color: AppColors.accentColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }
}

// كلاس الزر المتحرك (Animated Submit Button)
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animOffset;
  bool _hasErrorState = false;

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
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasErrorState
                ? Colors.orange.shade800
                : AppColors.accentColor,
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
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _hasErrorState
                          ? Icons.refresh_rounded
                          : Icons.add_circle_outline_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      currentLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// كلاس رسم شعاع الضوء المتحرك حول حواف نافذة الـ Dialog
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
