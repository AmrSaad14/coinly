import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/verify_user_request_model.dart';
import '../../features/auth/data/models/verify_user_response_model.dart';
import '../../features/auth/data/models/complete_profile_request_model.dart';
import '../../features/auth/data/models/login_request_model.dart';
import '../../features/auth/data/models/login_response_model.dart';
import '../../features/kiosk/data/models/markets_response_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/users/verify')
  Future<VerifyUserResponseModel> verifyUser(
    @Body() VerifyUserRequestModel request,
  );

  @POST('/users/complete_profile')
  Future<Response<dynamic>> completeProfile(
    @Body() CompleteProfileRequestModel request,
    @Header('Authorization') String? authorization,
  );

  @POST('/oauth/token')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @GET('/api/v1/owner/markets')
  Future<MarketsResponseModel> getOwnerMarkets(
    @Header('Authorization') String authorization,
  );

  @POST('/api/v1/owner/markets')
  Future<Response<dynamic>> createMarket(
    @Body() Map<String, dynamic> request,
    @Header('Authorization') String authorization,
  );

  @POST('/logout')
  Future<Response<dynamic>> logout(
    @Header('Authorization') String authorization,
  );
}
