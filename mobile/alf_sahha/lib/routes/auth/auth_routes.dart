import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/login/login_model.dart';
import '../../models/register/register_model.dart';

part 'auth_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/auth/register')
  Future<RegisterModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/login')
  Future<LoginModel> login(@Body() Map<String, dynamic> body);
}
