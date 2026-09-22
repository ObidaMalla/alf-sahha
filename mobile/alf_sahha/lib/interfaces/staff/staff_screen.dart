import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/color/colors.dart';
import '../../cubits/results_state.dart';
import '../../cubits/staffCubit/staff_cubit.dart';
import '../../injections/bootStrap/staff/staff_injection.dart';
import '../../models/staff/staff_model.dart';
import '../../token/token_storage.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen>
    with SingleTickerProviderStateMixin {
  final GetStaffCubit _getCubit = getIt<GetStaffCubit>();
  final DeleteStaffCubit _deleteCubit = getIt<DeleteStaffCubit>();

  late final AnimationController _beamController;

  String? _restaurantId;

  @override
  void initState() {
    super.initState();
    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
    _loadRestaurantIdAndFetch();
  }

  Future<void> _loadRestaurantIdAndFetch() async {
    final id = await TokenStorage.getRestaurantId();
    if (mounted) {
      setState(() {
        _restaurantId = id;
      });
      if (id != null && id.isNotEmpty) {
        _getCubit.getStaff(restaurantId: id);
      }
    }
  }

  @override
  void dispose() {
    _beamController.dispose();
    _getCubit.close();
    _deleteCubit.close();
    super.dispose();
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    final date = DateTime.tryParse(iso)?.toLocal();
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmDelete(StaffData staff) async {
    if (_restaurantId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.errorColor.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.errorColor.withOpacity(0.12),
                  border: Border.all(
                    color: AppColors.errorColor.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: AppColors.errorColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'طرد "${staff.user?.name ?? ''}"؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'لن يتمكن من الوصول لحساب المطعم بعد الطرد',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.hintColor, fontSize: 12.5),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
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
                          backgroundColor: AppColors.errorColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'طرد',
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
      ),
    );

    if (confirmed == true && mounted) {
      _deleteCubit.deleteStaff(
        restaurantId: _restaurantId!,
        staffId: staff.id ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _getCubit),
        BlocProvider.value(value: _deleteCubit),
      ],
      child: BlocListener<DeleteStaffCubit, ResultState<DeleteStaffModel>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(data.message ?? 'تم طرد الموظف بنجاح'),
                  backgroundColor: AppColors.successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
              if (_restaurantId != null) {
                _getCubit.getStaff(restaurantId: _restaurantId!);
              }
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.errorColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
          );
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.surfaceColor,
              elevation: 0,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
              title: Text(
                'الموظفين',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_restaurantId != null) {
                      _getCubit.getStaff(restaurantId: _restaurantId!);
                    }
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: AppColors.accentColor,
                  ),
                ),
              ],
            ),
            body: BlocBuilder<GetStaffCubit, ResultState<GetStaffModel>>(
              builder: (context, state) {
                return state.when(
                  idle: () => const SizedBox.shrink(),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentColor,
                    ),
                  ),
                  error: (message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.errorColor,
                            size: 44,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  success: (data) {
                    final list = data.data ?? [];
                    if (list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              color: AppColors.textMuted,
                              size: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ما في موظفين حالياً',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.accentColor,
                      backgroundColor: AppColors.surfaceColor,
                      onRefresh: () async {
                        if (_restaurantId != null) {
                          await _getCubit.getStaff(
                            restaurantId: _restaurantId!,
                          );
                        }
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final staff = list[index];
                          return BlocBuilder<
                            DeleteStaffCubit,
                            ResultState<DeleteStaffModel>
                          >(
                            builder: (context, deleteState) {
                              final isDeleting = deleteState.maybeWhen(
                                loading: () => true,
                                orElse: () => false,
                              );
                              return _StaffCard(
                                staff: staff,
                                isDeleting: isDeleting,
                                beamController: _beamController,
                                formattedDate: _formatDate(staff.joinedAt),
                                onLongPress: isDeleting
                                    ? null
                                    : () => _confirmDelete(staff),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 💠 كارت موظف مع توهج متحرك حول الحدود
// ============================================================
class _StaffCard extends StatelessWidget {
  final StaffData staff;
  final bool isDeleting;
  final AnimationController beamController;
  final String formattedDate;
  final VoidCallback? onLongPress;

  const _StaffCard({
    required this.staff,
    required this.isDeleting,
    required this.beamController,
    required this.formattedDate,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: beamController,
      builder: (context, child) {
        return CustomPaint(
          painter: _BorderBeamPainter(
            animationValue: beamController.value,
            colorA: AppColors.goldColor,
            colorB: AppColors.accentColor,
            borderRadius: 18.0,
          ),
          child: child,
        );
      },
      child: Material(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.accentColor.withOpacity(0.15),
                  child: Text(
                    (staff.user?.name?.isNotEmpty == true)
                        ? staff.user!.name![0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.user?.name ?? 'بدون اسم',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 11,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'انضم بتاريخ $formattedDate',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isDeleting)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.errorColor,
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

// ============================================================
// 🌟 توهج متحرك حول حدود الكارت
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

    canvas.drawPath(
      path,
      Paint()
        ..color = blended.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    final metric = path.computeMetrics().first;
    final pathLength = metric.length;

    const int particleCount = 30;
    for (int i = 0; i < particleCount; i++) {
      final double progressOffset = i / particleCount;
      final double currentLoc =
          (pathLength * animationValue - (i * 2.5)) % pathLength;
      final double actualLoc = currentLoc < 0
          ? currentLoc + pathLength
          : currentLoc;

      final segment = metric.extractPath(actualLoc, actualLoc + 1.5);
      final double opacity = (1.0 - progressOffset) * 0.8;

      canvas.drawPath(
        segment,
        Paint()
          ..color = blended.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, i == 0 ? 3.0 : 1.0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.colorA != colorA ||
        oldDelegate.colorB != colorB ||
        oldDelegate.borderRadius != borderRadius;
  }
}
