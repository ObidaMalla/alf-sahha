import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/restaurantCubit/invite-codes/invite-codes_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../models/restaurant/invite-codes/invite_codes_model.dart';
import '../../../token/token_storage.dart';

class InviteCodeScreen extends StatelessWidget {
  const InviteCodeScreen({super.key});

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
            'أكواد الدعوات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<InviteCodeCubit, ResultState<InviteCodeModel>>(
          builder: (context, state) {
            return state.when(
              idle: () => _buildInitialView(context),
              loading: () => _buildLoading(),
              error: (message) => _buildError(context, message),
              success: (model) => _buildSuccess(context, model),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // INITIAL VIEW
  // ============================================================
  Widget _buildInitialView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.accentColor.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentColor.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 48,
                    color: AppColors.accentColor,
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'إنشاء كود دعوة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'قم بإنشاء كود جديد لمشاركة صلاحية الدخول إلى المطعم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, height: 1.6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () async {
                final restaurantId = await TokenStorage.getRestaurantId();

                if (restaurantId == null || restaurantId.isEmpty) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تعذر العثور على معرف المطعم'),
                    ),
                  );
                  return;
                }

                if (!context.mounted) return;

                context.read<InviteCodeCubit>().generateInviteCode(
                  restaurantId: restaurantId,
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text(
                'توليد كود جديد',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.accentColor),
          const SizedBox(height: 18),
          Text(
            'جاري إنشاء كود الدعوة...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUCCESS VIEW
  // ============================================================

  Widget _buildSuccess(BuildContext context, InviteCodeModel model) {
    final code = model.data?.code ?? '';
    final expiresAt = model.data?.expiresAt ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 120),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: AppColors.fireGradient,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.30),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'تم إنشاء الكود بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'شارك هذا الكود مع الشخص المطلوب',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Center(
                    child: SelectableText(
                      code,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                ),

                if (expiresAt.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: Colors.white70,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          'ينتهي في: ${_formatDate(expiresAt)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ============================================================
          // COPY BUTTON
          // ============================================================
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: code.isEmpty
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: code));

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).clearSnackBars();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'تم نسخ الكود بنجاح',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: AppColors.successColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.copy_rounded, size: 20),
              label: const Text(
                'نسخ الكود',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<InviteCodeCubit>().resetState();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentColor,
                side: BorderSide(color: AppColors.accentColor.withOpacity(0.6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(
                'إنشاء كود آخر',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.errorColor.withOpacity(0.20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.errorColor,
                  size: 40,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'تعذر إنشاء الكود',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.errorColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<InviteCodeCubit>().resetState();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    foregroundColor: AppColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'العودة والمحاولة مجدداً',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(String value) {
    try {
      final date = DateTime.parse(value).toLocal();

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;

      final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'مساءً' : 'صباحاً';

      return '$day/$month/$year - $hour12:$minute $period';
    } catch (_) {
      return value;
    }
  }
}
