import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/verify_user_request_model.dart';
import '../../features/auth/data/models/verify_user_response_model.dart';
import '../../features/auth/data/models/complete_profile_request_model.dart';
import '../../features/auth/data/models/login_request_model.dart';
import '../../features/auth/data/models/login_response_model.dart';
import '../../features/kiosk/data/models/markets_response_model.dart';
import '../../features/kiosk/data/models/market_model.dart';
import '../../features/home/data/models/owner_response_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/users/verify')
  Future<VerifyUserResponseModel> verifyUser(
    @Body() VerifyUserRequestModel request,
  );

  @POST('/users/complete_profile')
  @DioResponseType(ResponseType.json)
  Future<Response> completeProfile(
    @Body() CompleteProfileRequestModel request,
    @Header('Authorization') String? authorization,
  );

  @POST('/oauth/token')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @GET('/api/v1/owner/markets')
  Future<MarketsResponseModel> getOwnerMarkets(
    @Header('Authorization') String authorization,
  );

  @GET('/api/v1/owner/markets/{market_id}')
  Future<MarketModel> getMarketById(
    @Path('market_id') int marketId,
    @Header('Authorization') String authorization,
  );

  @POST('/api/v1/owner/markets')
  @DioResponseType(ResponseType.json)
  Future<Response> createMarket(
    @Body() Map<String, dynamic> request,
    @Header('Authorization') String authorization,
  );

  @POST('/logout')
  @DioResponseType(ResponseType.json)
  Future<Response> logout(
    @Header('Authorization') String authorization,
  );

  @GET('/api/v1/owner/me')
  Future<OwnerResponseModel> getOwnerMe(
    @Header('Authorization') String authorization,
  );
}
