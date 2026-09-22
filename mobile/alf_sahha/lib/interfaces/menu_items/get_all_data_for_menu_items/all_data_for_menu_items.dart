import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color/colors.dart';
import '../../../cubits/menu_items/all_data_for_menu_items/allDataForMenuItemsCubit.dart';
import '../../../cubits/orderCubit/cartCubit.dart';
import '../../../cubits/results_state.dart';
import '../../../injections/bootStrap/auth/_login/login_injection.dart';
import '../../../models/menu_item/all_data_for_menu/all_data_for_menu_items_model.dart';
import '../../../models/menu_item/update_element_in_menu_items/update_element_in_menu_items_model.dart';
import '../../../token/token_storage.dart';
import '../../orders/create_order/orderCheckoutScreen.dart';
import '../delete/deleteElementFromMenuItems.dart';
import '../updateMenuItem.dart';

class GetMenuItemsScreen extends StatefulWidget {
  final String restaurantId; // 👈 المعرف القادم من شاشة المطاعم

  const GetMenuItemsScreen({super.key, required this.restaurantId});

  @override
  State<GetMenuItemsScreen> createState() => _GetMenuItemsScreenState();
}

class _GetMenuItemsScreenState extends State<GetMenuItemsScreen> {
  // 👈 تعريف الـ Cubit وجلبه مباشرة من GetIt بدون BlocProvider
  late final GetMenuItemsCubit _menuItemsCubit;

  @override
  void initState() {
    super.initState();
    _menuItemsCubit = getIt<GetMenuItemsCubit>();
    // 👈 جلب الأصناف للمطعم المحدد حصراً
    _menuItemsCubit.getMenuItems(restaurantId: widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'أصناف المنيو',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: AppColors.backgroundSecondary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          actions: [
            BlocBuilder<CartCubit, List<CartItem>>(
              bloc: getIt<CartCubit>(),
              builder: (context, cart) {
                final cubit = getIt<CartCubit>();
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart_rounded,
                          color: AppColors.accentColor,
                          size: 25,
                        ),
                        onPressed: cart.isEmpty
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderCheckoutScreen(
                                    cartItems: cart,
                                    onOrderCompleted: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                      ),
                      if (cubit.totalQuantity > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.errorColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.backgroundSecondary,
                                width: 1.5,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cubit.totalQuantity}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<GetMenuItemsCubit, ResultState<GetAllMenuItemsModel>>(
          bloc: _menuItemsCubit, // 👈 تمرير الـ Cubit هنا مباشرة
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
              success: (GetAllMenuItemsModel response) {
                final items = response.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.fastfood_outlined,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد أصناف مضافة حالياً',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return MenuItemCard(
                        item: item,
                        restaurantId: widget.restaurantId,
                        onItemUpdated: () {
                          // 👈 إعادة جلب الأصناف عند التعديل/الحذف لنفس المطعم
                          _menuItemsCubit.getMenuItems(
                            restaurantId: widget.restaurantId,
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

        // شريط السلة العائم الذي يظهر تلقائياً عند إضافة أصناف
        bottomNavigationBar: BlocBuilder<CartCubit, List<CartItem>>(
          bloc: getIt<CartCubit>(),
          builder: (context, cart) {
            if (cart.isEmpty) return const SizedBox.shrink();
            final cubit = getIt<CartCubit>();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderCheckoutScreen(
                        cartItems: cart,
                        onOrderCompleted: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.fireGradient),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${cubit.totalQuantity} أصناف',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'عرض السلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${cubit.totalPrice.toStringAsFixed(0)} ل.س',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

class MenuItemCard extends StatefulWidget {
  final dynamic item;
  final String restaurantId;
  final VoidCallback onItemUpdated;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.restaurantId,
    required this.onItemUpdated,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with TickerProviderStateMixin {
  late final AnimationController _beamController;
  String? userRole;
  bool isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await TokenStorage.getRole();
    setState(() {
      userRole = role;
      isLoadingRole = false;
    });
  }

  @override
  void dispose() {
    _beamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final bool canEdit =
        !isLoadingRole &&
        (userRole?.toUpperCase() == 'OWNER' ||
            userRole?.toUpperCase() == 'EMPLOYEE');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
        animation: _beamController,
        builder: (context, child) {
          return CustomPaint(
            painter: _BorderBeamPainter(
              animationValue: _beamController.value,
              colorA: AppColors.drinkColor,
              colorB: AppColors.dessertColor,
              borderRadius: 16.0,
            ),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? Image.network(
                          item.imageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? 'بدون اسم',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (canEdit)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: AppColors.accentColor,
                                ),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                onPressed: () async {
                                  final updateModelData =
                                      DataUpdateElementInMenuItemsModel(
                                        id: item.id,
                                        restaurantId: item.restaurantId,
                                        name: item.name,
                                        description: item.description,
                                        price: item.price,
                                        category: item.category,
                                        imageUrl: item.imageUrl,
                                        isAvailable: item.isAvailable,
                                      );

                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateMenuItemScreen(
                                            itemId: item.id,
                                            restaurantId: widget.restaurantId,
                                            initialItem: updateModelData,
                                          ),
                                    ),
                                  );

                                  if (result == true) {
                                    widget.onItemUpdated();
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                  color: AppColors.errorColor,
                                ),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteMenuItemScreen(
                                            itemId: item.id,
                                            itemName: item.name ?? 'هذا الطبق',
                                          ),
                                    ),
                                  );

                                  if (result == true) {
                                    widget.onItemUpdated();
                                  }
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description ?? 'لا يوجد وصف متاح',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.price ?? '0'} ل.س',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentColor,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: (item.isAvailable ?? false)
                                    ? AppColors.successColor.withOpacity(0.15)
                                    : AppColors.errorColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (item.isAvailable ?? false)
                                    ? 'متاح'
                                    : 'غير متاح',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: (item.isAvailable ?? false)
                                      ? AppColors.successColor
                                      : AppColors.errorColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: AppColors.accentColor,
                                size: 20,
                              ),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                getIt<CartCubit>().addItem(
                                  menuItemId: item.id ?? '',
                                  restaurantId: item.restaurantId ?? '',
                                  name: item.name ?? '',
                                  price: num.tryParse(item.price ?? '0') ?? 0,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تمت إضافة ${item.name} للسلة',
                                    ),
                                    backgroundColor: AppColors.successColor,
                                    duration: const Duration(milliseconds: 800),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.accentColorSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.fastfood_rounded,
        color: AppColors.accentColor,
        size: 30,
      ),
    );
  }
}

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
