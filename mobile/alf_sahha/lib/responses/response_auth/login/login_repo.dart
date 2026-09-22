import '../../../models/login/login_model.dart';
import '../../../routes/auth/auth_routes.dart';
import '../../apiExceptionHandler.dart';

class LoginRepository {
  final AuthService authService;
  LoginRepository(this.authService);

  Future<LoginModel> login({
    required String email,
    required String password,
    String? fcmToken, // 👈 جديد
  }) {
    return ApiExceptionHandler.handle<LoginModel>(
      () => authService.login({
        'email': email,
        'password': password,
        if (fcmToken != null) 'fcmToken': fcmToken, // 👈 جديد
      }),
      fallbackErrorMessage: 'فشلت عملية تسجيل الدخول 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
