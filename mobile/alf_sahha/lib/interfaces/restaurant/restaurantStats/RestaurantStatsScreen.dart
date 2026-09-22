import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/restaurantCubit/restaurant_stats/restaurant_stats_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/restaurant/restaurant_stats/restaurant_stats_injection.dart';
import '../../../models/restaurant/restaurant_stats/restaurant_stats_model.dart';
import '../../../token/token_storage.dart';

class RestaurantStatsScreen extends StatefulWidget {
  const RestaurantStatsScreen({super.key});

  @override
  State<RestaurantStatsScreen> createState() => _RestaurantStatsScreenState();
}

class _RestaurantStatsScreenState extends State<RestaurantStatsScreen> {
  late final RestaurantStatsCubit _cubit;
  String? _resolvedRestaurantId;
  bool _isLoadingId = true;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RestaurantStatsCubit>();
    _loadRestaurantIdAndStats();
  }

  Future<void> _loadRestaurantIdAndStats() async {
    final id = await TokenStorage.getRestaurantId();

    setState(() {
      _resolvedRestaurantId = id;
      _isLoadingId = false;
    });

    if (_resolvedRestaurantId != null && _resolvedRestaurantId!.isNotEmpty) {
      _cubit.getStats(_resolvedRestaurantId!);
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
            'إحصائيات المطعم',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: _isLoadingId
            ? Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              )
            : (_resolvedRestaurantId == null || _resolvedRestaurantId!.isEmpty)
            ? Center(
                child: Text(
                  'لم يتم العثور على معرف المطعم',
                  style: TextStyle(color: AppColors.errorColor),
                ),
              )
            : BlocBuilder<
                RestaurantStatsCubit,
                ResultState<RestaurantStatsModel>
              >(
                bloc: _cubit,
                builder: (context, state) {
                  return state.when(
                    idle: () => const SizedBox.shrink(),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentColor,
                      ),
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
                          Text(
                            msg,
                            style: TextStyle(color: AppColors.errorColor),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                _cubit.getStats(_resolvedRestaurantId!),
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
                      final byStatus = data?.ordersByStatus;

                      final cards = <_StatCardData>[
                        _StatCardData(
                          title: 'إجمالي الطلبات',
                          value: '${data?.totalOrders ?? 0}',
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.accentColor,
                          isHighlighted: true,
                        ),
                        _StatCardData(
                          title: 'إجمالي الإيرادات',
                          value: '${data?.totalRevenue ?? '0'} ل.س',
                          icon: Icons.monetization_on_rounded,
                          color: AppColors.goldColor,
                          isHighlighted: true,
                        ),
                        _StatCardData(
                          title: 'قيد الانتظار',
                          value: '${byStatus?.PENDING ?? 0}',
                          icon: Icons.hourglass_top_rounded,
                          color: AppColors.goldColor,
                        ),
                        _StatCardData(
                          title: 'مقبولة',
                          value: '${byStatus?.ACCEPTED ?? 0}',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.infoColor,
                        ),
                        _StatCardData(
                          title: 'قيد التحضير',
                          value: '${byStatus?.PREPARING ?? 0}',
                          icon: Icons.soup_kitchen_rounded,
                          color: AppColors.accentColor,
                        ),
                        _StatCardData(
                          title: 'مكتملة',
                          value: '${byStatus?.COMPLETED ?? 0}',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.successColor,
                        ),
                        _StatCardData(
                          title: 'مرفوضة',
                          value: '${byStatus?.REJECTED ?? 0}',
                          icon: Icons.cancel_rounded,
                          color: AppColors.errorColor,
                        ),
                        _StatCardData(
                          title: 'منتهية الصلاحية',
                          value: '${byStatus?.EXPIRED ?? 0}',
                          icon: Icons.timer_off_rounded,
                          color: AppColors.textMuted,
                        ),
                      ];

                      return RefreshIndicator(
                        color: AppColors.accentColor,
                        onRefresh: () async =>
                            _cubit.getStats(_resolvedRestaurantId!),
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 216),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,

                                // الرقم الأصغر = الكرت أطول
                                childAspectRatio: 0.82,
                              ),
                          itemCount: cards.length,
                          itemBuilder: (context, index) =>
                              _buildStatCard(cards[index]),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatCard(_StatCardData card) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: card.isHighlighted
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [card.color.withOpacity(0.22), AppColors.cardColor],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [card.color.withOpacity(0.08), AppColors.cardColor],
              ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: card.color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: card.color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================
          // Header
          // ===========================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  card.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: card.color.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(card.icon, color: card.color, size: 25),
              ),
            ],
          ),

          // ===========================
          // Value
          // ===========================
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  card.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 27,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  _StatCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });
}
