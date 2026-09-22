import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notificateionService/notificationService.dart';
import '../../models/login/login_model.dart';
import '../../responses/response_auth/login/login_repo.dart';
import '../../token/token_storage.dart';
import '../results_state.dart';

class LoginCubit extends Cubit<ResultState<LoginModel>> {
  final LoginRepository loginRepo;
  LoginCubit(this.loginRepo) : super(const ResultState.idle());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      // 👇 جديد — جلب FCM token بأمان قبل الطلب
      String? fcmToken;
      try {
        fcmToken = await NotificationService.getFcmToken();
      } catch (e) {
        debugPrint('⚠️ [LoginCubit] فشل جلب fcmToken: $e');
      }

      final response = await loginRepo.login(
        email: email,
        password: password,
        fcmToken: fcmToken, // 👈 جديد
      );

      final token = response.data?.token;
      final role = response.data?.user?.role;
      final restaurantId = response.data?.user?.restaurantId;

      if (token != null) {
        await TokenStorage.saveToken(token);
      }
      if (role != null) {
        await TokenStorage.saveRole(role);
      }
      if (restaurantId != null) {
        await TokenStorage.saveRestaurantId(restaurantId);
      }

      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  void resetState() {
    emit(const ResultState.idle());
  }
}
