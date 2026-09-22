import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/restaurant/invite-codes/invite_codes_model.dart';
import '../../../responses/response_restaurant/invite-codes/invite-codes_repo.dart';
import '../../results_state.dart';

class InviteCodeCubit extends Cubit<ResultState<InviteCodeModel>> {
  final InviteCodeRepository inviteCodeRepository;

  InviteCodeCubit(this.inviteCodeRepository) : super(const ResultState.idle());

  Future<void> generateInviteCode({required String restaurantId}) async {
    emit(const ResultState.loading());

    try {
      final response = await inviteCodeRepository.generateInviteCode(
        restaurantId: restaurantId,
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
