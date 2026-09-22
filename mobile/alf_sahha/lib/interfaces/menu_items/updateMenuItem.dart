import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/results_state.dart';
import '../../cubits/menu_items/updateMenuItemCubit/updateMenuItem_cubit.dart';
import '../../models/menu_item/update_element_in_menu_items/update_element_in_menu_items_model.dart';

class UpdateMenuItemScreen extends StatefulWidget {
  final String itemId;
  final String restaurantId;
  final DataUpdateElementInMenuItemsModel initialItem;

  const UpdateMenuItemScreen({
    super.key,
    required this.itemId,
    required this.restaurantId,
    required this.initialItem,
  });

  @override
  State<UpdateMenuItemScreen> createState() => _UpdateMenuItemScreenState();
}

class _UpdateMenuItemScreenState extends State<UpdateMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialItem.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialItem.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialItem.price ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.initialItem.category ?? 'FOOD',
    );
    _isAvailable = widget.initialItem.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'تعديل الصنف',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.backgroundSecondary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: AppColors.borderColor, height: 1.0),
          ),
        ),
        body:
            BlocConsumer<
              UpdateMenuItemCubit,
              ResultState<UpdateElementInMenuItemsModel>
            >(
              listener: (context, state) {
                state.whenOrNull(
                  success: (response) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.message ?? 'تم تعديل الصنف بنجاح',
                        ),
                        backgroundColor: AppColors.successColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context, true);
                  },
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
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

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // معاينة الصورة إن وجدت
                        if (widget.initialItem.imageUrl != null &&
                            widget.initialItem.imageUrl!.isNotEmpty)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.borderColorLight,
                                  width: 1.5,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.initialItem.imageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                        const Text(
                          'المعلومات الأساسية',
                          style: TextStyle(
                            color: AppColors.goldColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // اسم الصنف
                        _buildTextField(
                          controller: _nameController,
                          label: 'اسم الصنف',
                          icon: Icons.fastfood_rounded,
                          validator: (value) => value == null || value.isEmpty
                              ? 'اسم الصنف مطلوب'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // السعر
                        _buildTextField(
                          controller: _priceController,
                          label: 'السعر (ل.س)',
                          icon: Icons.attach_money_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? 'السعر مطلوب'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // التصنيف
                        _buildTextField(
                          controller: _categoryController,
                          label: 'التصنيف (Category)',
                          icon: Icons.category_rounded,
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'التفاصيل والحالة',
                          style: TextStyle(
                            color: AppColors.goldColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // الوصف
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'وصف الصنف',
                          icon: Icons.description_rounded,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // حالة التوفر مع Material لتجنب التحذير البصري
                        // حالة التوفر مع Material داخلية لتجنب التحذير البصري نهائياً
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'متوفر للطلب حالياً',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(
                                  _isAvailable
                                      ? 'القطعة تظهر للزبائن ويمكن طلبها'
                                      : 'القطعة مخفية أو غير متاحة',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                value: _isAvailable,
                                activeColor: AppColors.successColor,
                                onChanged: (value) {
                                  setState(() {
                                    _isAvailable = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // زر الحفظ
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppColors.fireGradient,
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        final body = {
                                          "name": _nameController.text.trim(),
                                          "description": _descriptionController
                                              .text
                                              .trim(),
                                          "price": _priceController.text.trim(),
                                          "category": _categoryController.text
                                              .trim(),
                                          "isAvailable": _isAvailable,
                                        };

                                        context
                                            .read<UpdateMenuItemCubit>()
                                            .updateMenuItem(
                                              itemId: widget.itemId,
                                              body: body,
                                            );
                                      }
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'حفظ التعديلات',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.accentColor, size: 22),
        filled: true,
        fillColor: AppColors.inputColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accentColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
      ),
    );
  }
}
