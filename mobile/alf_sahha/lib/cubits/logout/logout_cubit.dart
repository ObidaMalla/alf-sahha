import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/logout/logout_model.dart';
import '../../responses/logout/logout_response.dart';
import '../../token/token_storage.dart';
import '../results_state.dart';

class LogoutCubit extends Cubit<ResultState<LogoutModel>> {
  final LogoutRepository logoutRepo;
  LogoutCubit(this.logoutRepo) : super(const ResultState.idle());

  Future<void> logout() async {
    emit(const ResultState.loading());
    try {
      final response = await logoutRepo.logout();

      // مسح التوكن وبيانات الجلسة محلياً فوراً
      await TokenStorage.removeToken();

      debugPrint('✅ [LogoutCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [LogoutCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}
