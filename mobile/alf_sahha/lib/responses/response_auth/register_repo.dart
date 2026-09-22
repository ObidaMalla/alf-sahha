import '../../models/register/register_model.dart';
import '../../routes/auth/auth_routes.dart';
import '../apiExceptionHandler.dart';

class RegisterRepository {
  final AuthService authService;
  RegisterRepository(this.authService);

  Future<RegisterModel> register({
    required String email,
    required String password,
    required String name,
  }) {
    return ApiExceptionHandler.handle<RegisterModel>(
      () => authService.register({
        'email': email,
        'password': password,
        'name': name,
      }),
      fallbackErrorMessage: 'فشلت عملية إنشاء الحساب 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
