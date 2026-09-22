import 'package:alf_sahha/interfaces/profile/profileScreen.dart';
import 'package:alf_sahha/interfaces/restaurant/getDataRentaurants/getDataForALLRestaurant.dart';
import 'package:alf_sahha/interfaces/restaurant/inviteCodes/inviteCodeScreen.dart';
import 'package:alf_sahha/interfaces/restaurant/restaurantStats/RestaurantStatsScreen.dart';
import 'package:alf_sahha/interfaces/staff/staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/color/colors.dart';
import '../token/token_storage.dart';
import 'menu_items/addMenuItemScreen.dart';
import 'orders/get_all_orders/get_all_orders_screen.dart';
import 'orders/get_order_client/get_order_client_Screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final PageController _pageController;

  List<Widget> _pages = [];
  List<_NavItemData> _navItems = [];

  late final AnimationController _glowController;

  bool _isExitDialogShowing = false;
  bool _isLoadingRole = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _setupTabs();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _setupTabs() async {
    final role = await TokenStorage.getRole();
    final restaurantId = await TokenStorage.getRestaurantId() ?? '';

    if (!mounted) return;

    final pages = <Widget>[const RestaurantsScreen()];
    // 2. 👈 استبدال شاشة المنيو بشاشة المطاعم للموظف

    final navItems = <_NavItemData>[
      const _NavItemData(icon: Icons.storefront_rounded, label: 'المطاعم'),
    ];

    if (role == 'OWNER') {
      pages.add(const InviteCodeScreen());
      navItems.add(
        const _NavItemData(icon: Icons.qr_code_2_rounded, label: 'دعوات'),
      );
      pages.add(const StaffScreen());
      navItems.add(
        const _NavItemData(icon: Icons.badge_rounded, label: 'الموظفين'),
      );
      pages.add(const RestaurantStatsScreen());
      navItems.add(
        const _NavItemData(icon: Icons.bar_chart_rounded, label: 'الاحصائيات'),
      );
    }

    if (role == 'EMPLOYEE') {
      // 1. شاشة إضافة صنف للموظف
      pages.add(
        AddMenuItemScreen(
          restaurantId: restaurantId,
          onNavigateToTab: (index) => _onTabTapped(index),
        ),
      );
      navItems.add(
        const _NavItemData(icon: Icons.post_add_rounded, label: 'إضافة صنف'),
      );

      // 3. شاشة إدارة الطلبات للموظف
      pages.add(const GetAllOrdersScreen());
      navItems.add(
        const _NavItemData(icon: Icons.receipt_long_rounded, label: 'الطلبات'),
      );
    }

    if (role == 'CUSTOMER') {
      // 👈 استبدال شاشة المنيو بشاشة المطاعم للزبون
      pages.add(const RestaurantsScreen());
      navItems.add(
        const _NavItemData(icon: Icons.storefront_rounded, label: 'المطاعم'),
      );

      pages.add(const MyOrdersScreen());
      navItems.add(
        const _NavItemData(icon: Icons.receipt_long_rounded, label: 'طلباتي'),
      );
    }
    pages.add(const ProfileScreen());
    navItems.add(
      const _NavItemData(icon: Icons.person_rounded, label: 'الملف الشخصي'),
    );
    setState(() {
      _userRole = role;
      _pages = pages;
      _navItems = navItems;
      _isLoadingRole = false;
    });
  } // ANDROID BACK BUTTON
  // ============================================================

  Future<void> _handleBackButton() async {
    if (_currentIndex != 0) {
      _onTabTapped(0);
      return;
    }

    if (_isExitDialogShowing) {
      return;
    }

    _isExitDialogShowing = true;

    final shouldExit = await _showExitConfirmationDialog();

    _isExitDialogShowing = false;

    if (!mounted) {
      return;
    }

    if (shouldExit) {
      await SystemNavigator.pop();
    }
  }

  // ============================================================
  // EXIT DIALOG
  // ============================================================

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: AppColors.accentColor.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 35,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.05),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentColor.withOpacity(0.10),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentColor.withOpacity(0.10),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppColors.accentColor,
                    size: 29,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'إغلاق التطبيق؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'هل أنت متأكد من رغبتك في إغلاق التطبيق؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _dialogButton(
                        label: 'إلغاء',
                        filled: false,
                        onPressed: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dialogButton(
                        label: 'خروج',
                        filled: true,
                        onPressed: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  Widget _dialogButton({
    required String label,
    required bool filled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: Material(
        color: filled ? AppColors.accentColor : AppColors.inputColor,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: filled
                    ? AppColors.backgroundColor
                    : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TAB
  // ============================================================

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          _handleBackButton();
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBody: true,

          body: _isLoadingRole
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentColor,
                  ),
                )
              : PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _pages,
                ),

          bottomNavigationBar: _isLoadingRole ? null : _buildBottomNavigation(),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    final safeIndex = _currentIndex >= _navItems.length ? 0 : _currentIndex;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(24),

            // BORDER
            border: Border.all(color: AppColors.goldColorSoft, width: 1.5),
          ),
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = index == safeIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),

                      color: isSelected
                          ? Colors.transparent.withValues(alpha: .15)
                          : Colors.transparent,

                      border: Border.all(
                        color: isSelected
                            ? AppColors.goldColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          scale: isSelected ? 1.15 : 1,
                          child: Icon(
                            item.icon,
                            color: isSelected
                                ? AppColors.goldColor
                                : AppColors.textMuted,
                            size: isSelected ? 28 : 23,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.goldColor
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}
