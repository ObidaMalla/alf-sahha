import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/menu_items/deleteElementFromMenuItemsCubit/deleteElementFromMenuItems_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../models/menu_item/delete_element_form_menu_items/delete_menu_item_response_model.dart';

class DeleteMenuItemScreen extends StatelessWidget {
  final String itemId;
  final String itemName;

  const DeleteMenuItemScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'حذف صنف',
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
              DeleteMenuItemCubit,
              ResultState<DeleteMenuItemResponseModel>
            >(
              listener: (context, state) {
                state.whenOrNull(
                  success: (response) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.message ?? 'تم حذف الصنف بنجاح'),
                        backgroundColor: AppColors.successColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(
                      context,
                      true,
                    ); // إرجاع true لتحديث القائمة في الواجهة السابقة
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

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: AppColors.errorColor,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'هل أنت متأكد من رغبتك في حذف هذا الطبق؟',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // عرض اسم الطبق بشكل مميز وبارز
                      Text(
                        'طبق "$itemName"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.goldColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'لن تتمكن من استعادة هذا الطبق بعد اتمام عملية الحذف نهائياً.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // زر الحذف الرئيسي
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<DeleteMenuItemCubit>()
                                      .deleteMenuItem(itemId: itemId);
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
                                  'تأكيد الحذف',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // زر التراجع
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.borderColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context, false),
                          child: const Text(
                            'تراجع',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
