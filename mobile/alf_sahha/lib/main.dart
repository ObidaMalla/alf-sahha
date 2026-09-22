import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/notificateionService/notificationService.dart';
import 'cubits/loginCubit/login_cubit.dart';
import 'cubits/logout/logout_cubit.dart';
import 'cubits/menu_items/all_data_for_menu_items/allDataForMenuItemsCubit.dart';
import 'cubits/menu_items/deleteElementFromMenuItemsCubit/deleteElementFromMenuItems_cubit.dart';
import 'cubits/menu_items/menu_itemsCubit/menu_items_cubit.dart';
import 'cubits/menu_items/updateMenuItemCubit/updateMenuItem_cubit.dart';
import 'cubits/notifications/UnreadCountCubit.dart';
import 'cubits/notifications/notifications_cubit.dart';
import 'cubits/orderCubit/acceptCubit/acceptOrder_cubit.dart';
import 'cubits/orderCubit/completeCubit/complete_order_cubit.dart';
import 'cubits/orderCubit/create_order_cubit.dart';
import 'cubits/orderCubit/getAllOrdersCubit/get_all_orders_cubit.dart';
import 'cubits/orderCubit/payCubit/pay_order_cubit.dart';
import 'cubits/orderCubit/rejectOrderCubit/reject_order_cubit.dart';
import 'cubits/profile/profile_cubit.dart';
import 'cubits/redeemInviteCode/redeem_invite_code_cubit.dart';
import 'cubits/registerCubit/register_cubit.dart';
import 'cubits/restaurantCubit/create_restaurant_cubit.dart';
import 'cubits/restaurantCubit/getDataRestaurant/getDataRestaurant_cubit.dart';
import 'cubits/restaurantCubit/invite-codes/invite-codes_cubit.dart';
import 'cubits/restaurantCubit/restaurant_stats/restaurant_stats_cubit.dart';
import 'cubits/staffCubit/staff_cubit.dart';
import 'cubits/walletCubit/wallet_cubit.dart';
import 'injections/bootStrap/bootStrap_all_injection.dart';
import 'interfaces/SplashScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final getIt = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة Firebase
  await Firebase.initializeApp();

  setupDependencies();

  runApp(const MyApp());
  _initFcmTokenSafely();
}

/// دالة جلب الـ Token في الخلفية مع حماية من الأخطاء لتفادي تعليق الشاشة
Future<void> _initFcmTokenSafely() async {
  try {
    await NotificationService.initialize();

    String? fcmToken = await NotificationService.getFcmToken();

    debugPrint('==================== FCM TOKEN ====================');
    debugPrint(fcmToken ?? 'Token is null');
    debugPrint('==================================================');
  } catch (e) {
    debugPrint('⚠️ تعذر جلب FCM Token حالياً (سيتم الإرسال أثناء Login): $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(create: (_) => getIt<RegisterCubit>()),
        BlocProvider<LoginCubit>(create: (_) => getIt<LoginCubit>()),
        BlocProvider<WalletCubit>(create: (_) => getIt<WalletCubit>()),
        BlocProvider<CreateRestaurantCubit>(
          create: (_) => getIt<CreateRestaurantCubit>(),
        ),
        BlocProvider<InviteCodeCubit>(create: (_) => getIt<InviteCodeCubit>()),
        BlocProvider<RedeemInviteCodeCubit>(
          create: (_) => getIt<RedeemInviteCodeCubit>(),
        ),
        BlocProvider<MenuItemCubit>(create: (_) => getIt<MenuItemCubit>()),
        BlocProvider<GetMenuItemsCubit>(
          create: (_) => getIt<GetMenuItemsCubit>(),
        ),
        BlocProvider<UpdateMenuItemCubit>(
          create: (_) => getIt<UpdateMenuItemCubit>(),
        ),
        BlocProvider<DeleteMenuItemCubit>(
          create: (_) => getIt<DeleteMenuItemCubit>(),
        ),
        BlocProvider<CreateOrderCubit>(
          create: (_) => getIt<CreateOrderCubit>(),
        ),
        BlocProvider<GetAllOrdersCubit>(
          create: (_) => getIt<GetAllOrdersCubit>(),
        ),
        BlocProvider<AcceptOrderCubit>(
          create: (_) => getIt<AcceptOrderCubit>(),
        ),
        BlocProvider<RejectOrderCubit>(
          create: (_) => getIt<RejectOrderCubit>(),
        ),
        BlocProvider<PayOrderCubit>(create: (_) => getIt<PayOrderCubit>()),
        BlocProvider<CompleteOrderCubit>(
          create: (_) => getIt<CompleteOrderCubit>(),
        ),
        BlocProvider<RestaurantsCubit>(
          create: (_) => getIt<RestaurantsCubit>(),
        ),
        BlocProvider<NotificationsCubit>(
          create: (_) => getIt<NotificationsCubit>(),
        ),
        BlocProvider<UnreadCountCubit>(
          create: (_) => getIt<UnreadCountCubit>(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<GetStaffCubit>(create: (_) => getIt<GetStaffCubit>()),
        BlocProvider<DeleteStaffCubit>(
          create: (_) => getIt<DeleteStaffCubit>(),
        ),
        BlocProvider<LogoutCubit>(create: (_) => getIt<LogoutCubit>()),
        BlocProvider<RestaurantStatsCubit>(
          create: (_) => getIt<RestaurantStatsCubit>(),
        ),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const SplashScreen(),
      ),
    );
  }
}
