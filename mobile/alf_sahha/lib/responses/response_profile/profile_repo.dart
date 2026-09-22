import '../../models/profile/profile_model.dart';
import '../../routes/profile/profile_routes.dart';
import '../apiExceptionHandler.dart';

class ProfileRepository {
  final ProfileService profileService;
  ProfileRepository(this.profileService);

  Future<ProfileModel> getProfile() {
    return ApiExceptionHandler.handle<ProfileModel>(
      () => profileService.getProfile(),
      fallbackErrorMessage: 'فشل جلب البروفايل 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }

  Future<ProfileModel> updateProfile({
    String? email,
    String? newPassword,
    required String currentPassword,
  }) {
    return ApiExceptionHandler.handle<ProfileModel>(
      () => profileService.updateProfile({
        'currentPassword': currentPassword,
        if (email != null) 'email': email,
        if (newPassword != null) 'newPassword': newPassword,
      }),
      fallbackErrorMessage: 'فشل تحديث البيانات 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
