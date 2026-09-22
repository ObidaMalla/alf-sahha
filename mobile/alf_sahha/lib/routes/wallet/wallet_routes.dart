import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/constants/api_constants.dart';
import '../../models/wallet/wallet_model.dart';

part 'wallet_routes.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class WalletService {
  factory WalletService(Dio dio, {String baseUrl}) = _WalletService;

  @GET('/wallet')
  Future<WalletModel> getWallet();
}
