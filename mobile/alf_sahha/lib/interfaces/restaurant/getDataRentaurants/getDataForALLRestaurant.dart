import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../core/notification_bell_icon.dart';
import '../../../cubits/restaurantCubit/getDataRestaurant/getDataRestaurant_cubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/restaurant/getDataRestaurants/restaurants_data_model.dart';
import '../../menu_items/get_all_data_for_menu_items/all_data_for_menu_items.dart';
import '../createRestaurant/create_restaurant_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen>
    with SingleTickerProviderStateMixin {
  late final RestaurantsCubit _restaurantsCubit;
  late final AnimationController _glowController; // 👈 جديد

  @override
  void initState() {
    super.initState();
    _restaurantsCubit = getIt<RestaurantsCubit>();
    _restaurantsCubit.getRestaurants();

    _glowController = AnimationController(
      // 👈 جديد
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose(); // 👈 جديد
    _restaurantsCubit.close();

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
            'المطاعم',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: AppColors.surfaceColor, // 👈 لون مختلف عن الـ body
          elevation: 0,
          centerTitle: true,
          actions: [
            Tooltip(
              message: 'الإشعارات',
              decoration: BoxDecoration(
                color: AppColors.goldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
              child: const NotificationBellIcon(),
            ),
            Tooltip(
              message: 'إنشاء مطعم',
              decoration: BoxDecoration(
                color: AppColors.goldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add_business_rounded,
                  color: AppColors.goldColor,
                  size: 30,
                ),
                onPressed: () {
                  // 👈 الضغط العادي (Tap) بينقلك للشاشة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRestaurantScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocConsumer<RestaurantsCubit, ResultState<RestaurantsResponseModel>>(
          bloc:
              _restaurantsCubit, // 👈 استخدام Cubit المعرّف عبر GetIt بدون BlocProvider
          listener: (context, state) {
            state.whenOrNull(
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox.shrink(),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
              success: (RestaurantsResponseModel response) {
                final restaurants = response.data ?? [];

                if (restaurants.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد مطاعم متاحة حالياً',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        glowController: _glowController, // 👈 جديد

                        onTap: () {
                          // عند الضغط على المطعم، ننتقل لـ المنيو ونمرر الـ restaurantId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GetMenuItemsScreen(
                                restaurantId: restaurant.id ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.errorColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// تصميم بطاقة المطعم
class RestaurantCard extends StatelessWidget {
  final RestaurantItem restaurant;
  final VoidCallback onTap;
  final AnimationController glowController;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    required this.glowController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
        animation: glowController,
        builder: (context, child) {
          return CustomPaint(
            painter: _GoldBorderBeamPainter(
              animationValue: glowController.value,
              borderRadius: 16.0,
            ),
            child: child,
          );
        },
        child: Material(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        restaurant.imageUrl != null &&
                            restaurant.imageUrl!.isNotEmpty
                        ? Image.network(
                            restaurant.imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name ?? 'مطعم بدون اسم',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.description ?? 'لا يوجد وصف متاح',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.accentColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                restaurant.address ?? 'العنوان غير متوفر',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.spicyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.accentColorSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.restaurant_rounded,
        color: AppColors.accentColor,
        size: 30,
      ),
    );
  }
}

// ============================================================
// 🌟 توهج ذهبي يدور حول حدود الكارت
// ============================================================
class _GoldBorderBeamPainter extends CustomPainter {
  final double animationValue;
  final double borderRadius;

  _GoldBorderBeamPainter({
    required this.animationValue,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.goldColor.withValues(alpha: 0.08)
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
          ..color = AppColors.goldColor.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, i == 0 ? 3.0 : 1.0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GoldBorderBeamPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
