import '../../models/logout/logout_model.dart';
import '../../routes/logout/logout_route.dart';
import '../apiExceptionHandler.dart';

class LogoutRepository {
  final LogoutService logoutService;
  LogoutRepository(this.logoutService);

  Future<LogoutModel> logout() {
    return ApiExceptionHandler.handle<LogoutModel>(
      () => logoutService.logout(),
      fallbackErrorMessage: 'فشلت عملية تسجيل الخروج 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
