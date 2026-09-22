import 'package:get_it/get_it.dart';

import '../../../cubits/walletCubit/wallet_cubit.dart';
import '../../../responses/response_wallet/wallet_repo.dart';
import '../../../routes/wallet/wallet_routes.dart';
import '../../dio_config.dart';

final getIt = GetIt.instance;

void initGetItWallet() {
  if (!getIt.isRegistered<WalletCubit>()) {
    getIt.registerFactory<WalletCubit>(
      () => WalletCubit(getIt<WalletRepository>()),
    );
  }
  if (!getIt.isRegistered<WalletRepository>()) {
    getIt.registerLazySingleton<WalletRepository>(
      () => WalletRepository(getIt<WalletService>()),
    );
  }
  if (!getIt.isRegistered<WalletService>()) {
    getIt.registerLazySingleton<WalletService>(
      () => WalletService(createAndSetupDio()),
    );
  }
}
