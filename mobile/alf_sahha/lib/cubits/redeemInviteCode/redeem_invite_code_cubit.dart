import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/redeemInviteCode/redeem_invite_code_model.dart';
import '../../responses/response_redeem_invite_code/redeem_invite_code_repo.dart';
import '../../token/token_storage.dart';
import '../results_state.dart';

class RedeemInviteCodeCubit extends Cubit<ResultState<RedeemInviteCodeModel>> {
  final RedeemInviteCodeRepository redeemInviteCodeRepo;
  RedeemInviteCodeCubit(this.redeemInviteCodeRepo)
    : super(const ResultState.idle());

  Future<void> redeemCode({required String code}) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await redeemInviteCodeRepo.redeemCode(code: code);

      // ===== تحديث التوكن والصلاحية محلياً (زي ما طلبت) =====
      final newToken = response.data?.token;
      if (newToken != null) {
        await TokenStorage.saveToken(newToken);
        await TokenStorage.saveRole('EMPLOYEE');
      }

      debugPrint('✅ [RedeemInviteCodeCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [RedeemInviteCodeCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}
