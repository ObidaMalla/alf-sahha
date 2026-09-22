import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/profile/profile_model.dart';
import '../../responses/response_profile/profile_repo.dart';
import '../results_state.dart';

class ProfileCubit extends Cubit<ResultState<ProfileModel>> {
  final ProfileRepository profileRepo;
  ProfileCubit(this.profileRepo) : super(const ResultState.idle());

  Future<void> getProfile() async {
    emit(const ResultState.loading());
    try {
      final response = await profileRepo.getProfile();
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  Future<void> updateProfile({
    String? email,
    String? newPassword,
    required String currentPassword,
  }) async {
    emit(const ResultState.loading());
    try {
      final response = await profileRepo.updateProfile(
        email: email,
        newPassword: newPassword,
        currentPassword: currentPassword,
      );
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
