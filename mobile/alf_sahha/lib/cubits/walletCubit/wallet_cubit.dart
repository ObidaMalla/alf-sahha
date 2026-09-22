import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/wallet/wallet_model.dart';
import '../../responses/response_wallet/wallet_repo.dart';
import '../results_state.dart';

class WalletCubit extends Cubit<ResultState<WalletModel>> {
  final WalletRepository walletRepo;
  WalletCubit(this.walletRepo) : super(const ResultState.idle());

  Future<void> getWallet() async {
    emit(const ResultState.loading());
    try {
      final response = await walletRepo.getWallet();
      emit(ResultState.success(response));
    } catch (error) {
      emit(ResultState.error(error is String ? error : error.toString()));
    }
  }
}
