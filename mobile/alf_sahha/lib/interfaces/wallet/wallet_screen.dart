import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/color/colors.dart';
import '../../cubits/results_state.dart';
import '../../cubits/walletCubit/wallet_cubit.dart';
import '../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../models/wallet/wallet_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletCubit _cubit; // 👈 مباشرة من GetIt، بلا BlocProvider

  @override
  void initState() {
    super.initState();
    _cubit = getIt<WalletCubit>();
    _cubit.getWallet();
  }

  // ============================================================
  // تحويل نوع المعاملة (الكود الخام) لنص عربي واضح
  // ============================================================
  String _typeLabel(String? type) {
    switch (type) {
      case 'ORDER_PAYMENT':
        return 'دفع طلب';
      case 'REFUND':
        return 'استرجاع مبلغ';
      case 'TOP_UP':
        return 'شحن رصيد';
      case 'WITHDRAWAL':
        return 'سحب رصيد';
      case 'SIGNUP_BONUS':
        return 'مكافأة التسجيل'; // 👈 تمت إضافة ترجمة المكافأة
      default:
        return type ?? 'معاملة';
    }
  }

  // هل المعاملة "دخل" (بالإضافة) أو "خرج" (بالخصم) — لتحديد اللون والإشارة
  bool _isIncoming(String? type) {
    return type == 'REFUND' ||
        type == 'TOP_UP' ||
        type == 'SIGNUP_BONUS'; // 👈 اعتبار مكافأة التسجيل معاملة دخول (إضافة)
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'ORDER_PAYMENT':
        return Icons.shopping_bag_rounded;
      case 'REFUND':
        return Icons.replay_circle_filled_rounded;
      case 'TOP_UP':
        return Icons.add_circle_rounded;
      case 'WITHDRAWAL':
        return Icons.remove_circle_rounded;
      case 'SIGNUP_BONUS':
        return Icons.card_giftcard_rounded; // 👈 أيقونة خاصة لمكافأة التسجيل
      default:
        return Icons.receipt_long_rounded;
    }
  }

  // ============================================================
  // تحويل التاريخ لتوقيت محلي (سوريا) بصيغة مفهومة
  // ============================================================
  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final parsed = DateTime.parse(isoDate).toLocal();

      final dayNames = [
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      final dayName = dayNames[parsed.weekday - 1];

      final hour12 = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
      final period = parsed.hour >= 12 ? 'مساءً' : 'صباحاً';
      final minute = parsed.minute.toString().padLeft(2, '0');

      return '$dayName $hour12:$minute $period';
    } catch (_) {
      return isoDate;
    }
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
            'محفظتك',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ),
        body: BlocBuilder<WalletCubit, ResultState<WalletModel>>(
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
                      onPressed: () => _cubit.getWallet(),
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
                final data = model.data;
                final balance = num.tryParse(data?.balance ?? '0') ?? 0;
                final transactions = data?.transactions ?? [];

                return RefreshIndicator(
                  color: AppColors.accentColor,
                  onRefresh: () async => _cubit.getWallet(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildBalanceCard(balance),
                      const SizedBox(height: 24),
                      Text(
                        'قائمة المعاملات',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              'لا توجد معاملات حالياً',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        ...transactions.map((tx) => _buildTransactionTile(tx)),
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

  // ============================================================
  // كارت الرصيد
  // ============================================================
  Widget _buildBalanceCard(num balance) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.fireGradient,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'رصيدك الحالي',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${balance.toStringAsFixed(0)} ل.س',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            balance > 0
                ? 'رصيدك جاهز لطلب وجبتك القادمة 🍽️'
                : 'رصيدك فارغ، اشحن محفظتك الآن',
            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // كارت معاملة واحدة
  // ============================================================
  Widget _buildTransactionTile(WalletTransaction tx) {
    final incoming = _isIncoming(tx.type);
    final color = incoming ? AppColors.successColor : AppColors.spicyColor;
    final amount = num.tryParse(tx.amount ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon(tx.type), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _typeLabel(tx.type),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatDate(tx.createdAt),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${incoming ? '+' : '-'}${amount.toStringAsFixed(0)} ل.س',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
