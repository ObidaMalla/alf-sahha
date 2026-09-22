import '../../../models/restaurant/invite-codes/invite_codes_model.dart';
import '../../../routes/restaurant/restaurant_routes.dart';
import '../../apiExceptionHandler.dart';

class InviteCodeRepository {
  final RestaurantService restaurantService;

  InviteCodeRepository(this.restaurantService);

  Future<InviteCodeModel> generateInviteCode({required String restaurantId}) {
    return ApiExceptionHandler.handle<InviteCodeModel>(
      () => restaurantService.generateInviteCode(restaurantId),
      fallbackErrorMessage: 'فشل توليد كود الدعوة 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
