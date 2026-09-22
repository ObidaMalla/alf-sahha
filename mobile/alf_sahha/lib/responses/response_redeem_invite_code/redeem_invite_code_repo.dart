import '../../models/redeemInviteCode/redeem_invite_code_model.dart';
import '../../routes/restaurant/restaurant_routes.dart';
import '../apiExceptionHandler.dart';

class RedeemInviteCodeRepository {
  final RestaurantService restaurantService;
  RedeemInviteCodeRepository(this.restaurantService);

  Future<RedeemInviteCodeModel> redeemCode({required String code}) {
    return ApiExceptionHandler.handle<RedeemInviteCodeModel>(
      () => restaurantService.redeemCode({'code': code}),
      fallbackErrorMessage: 'فشل قبول الكود 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
