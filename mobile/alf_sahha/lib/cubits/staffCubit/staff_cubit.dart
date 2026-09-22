import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/staff/staff_model.dart';
import '../../responses/response_staff/staff_repo.dart';
import '../results_state.dart';

class GetStaffCubit extends Cubit<ResultState<GetStaffModel>> {
  final StaffRepository staffRepo;
  GetStaffCubit(this.staffRepo) : super(const ResultState.idle());

  Future<void> getStaff({required String restaurantId}) async {
    emit(const ResultState.loading());
    try {
      final response = await staffRepo.getStaff(restaurantId: restaurantId);
      debugPrint('✅ [GetStaffCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [GetStaffCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}

class DeleteStaffCubit extends Cubit<ResultState<DeleteStaffModel>> {
  final StaffRepository staffRepo;
  DeleteStaffCubit(this.staffRepo) : super(const ResultState.idle());

  Future<void> deleteStaff({
    required String restaurantId,
    required String staffId,
  }) async {
    final isAlreadyLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    if (isAlreadyLoading) return;

    emit(const ResultState.loading());
    try {
      final response = await staffRepo.deleteStaff(
        restaurantId: restaurantId,
        staffId: staffId,
      );
      debugPrint('✅ [DeleteStaffCubit] Success: ${response.message}');
      emit(ResultState.success(response));
    } catch (error) {
      final String message = error is String ? error : error.toString();
      debugPrint('❌ [DeleteStaffCubit] $message');
      emit(ResultState.error(message));
    }
  }

  void resetState() => emit(const ResultState.idle());
}
