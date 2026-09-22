import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/register/register_model.dart';
import '../../responses/response_auth/register_repo.dart';
import '../results_state.dart';

class RegisterCubit extends Cubit<ResultState<RegisterModel>> {
  final RegisterRepository registerRepo;
  RegisterCubit(this.registerRepo) : super(const ResultState.idle());

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const ResultState.loading());
    try {
      final response = await registerRepo.register(
        email: email,
        password: password,
        name: name,
      );
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }

  void resetState() {
    emit(const ResultState.idle());
  }
}
