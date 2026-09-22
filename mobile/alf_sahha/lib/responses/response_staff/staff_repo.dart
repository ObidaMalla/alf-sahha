import '../../models/staff/staff_model.dart';
import '../../routes/staff/staff_routes.dart';
import '../apiExceptionHandler.dart';

class StaffRepository {
  final StaffService staffService;
  StaffRepository(this.staffService);

  Future<GetStaffModel> getStaff({required String restaurantId}) {
    return ApiExceptionHandler.handle<GetStaffModel>(
      () => staffService.getStaff(restaurantId),
      fallbackErrorMessage: 'فشل جلب الموظفين 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }

  Future<DeleteStaffModel> deleteStaff({
    required String restaurantId,
    required String staffId,
  }) {
    return ApiExceptionHandler.handle<DeleteStaffModel>(
      () => staffService.deleteStaff(restaurantId, staffId),
      fallbackErrorMessage: 'فشل طرد الموظف 🧨',
      isSuccess: (r) => r.success == true,
      extractMessage: (r) => r.message,
    );
  }
}
