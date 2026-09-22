import '../../models/wallet/wallet_model.dart';
import '../../routes/wallet/wallet_routes.dart';
import '../apiExceptionHandler.dart';

class WalletRepository {
  final WalletService walletService;
  WalletRepository(this.walletService);

  Future<WalletModel> getWallet() {
    return ApiExceptionHandler.handle<WalletModel>(
      () => walletService.getWallet(),
      fallbackErrorMessage: 'فشل جلب بيانات المحفظة 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
