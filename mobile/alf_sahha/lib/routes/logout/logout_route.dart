import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/logout/logout_model.dart';

part 'logout_route.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class LogoutService {
  factory LogoutService(Dio dio, {String baseUrl}) = _LogoutService;

  @POST('/auth/logout')
  Future<LogoutModel> logout();
}
