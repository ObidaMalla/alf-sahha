import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/staff/staff_model.dart';

part 'staff_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StaffService {
  factory StaffService(Dio dio, {String baseUrl}) = _StaffService;

  @GET('/restaurants/{restaurantId}/staff')
  Future<GetStaffModel> getStaff(@Path('restaurantId') String restaurantId);

  @DELETE('/restaurants/{restaurantId}/staff/{staffId}')
  Future<DeleteStaffModel> deleteStaff(
    @Path('restaurantId') String restaurantId,
    @Path('staffId') String staffId,
  );
}
