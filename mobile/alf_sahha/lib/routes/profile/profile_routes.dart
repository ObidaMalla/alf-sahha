import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/profile/profile_model.dart';

part 'profile_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProfileService {
  factory ProfileService(Dio dio, {String baseUrl}) = _ProfileService;

  @GET('/profile')
  Future<ProfileModel> getProfile();

  @PATCH('/profile')
  Future<ProfileModel> updateProfile(@Body() Map<String, dynamic> body);
}
