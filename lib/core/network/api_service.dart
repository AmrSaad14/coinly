import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/verify_user_request_model.dart';
import '../../features/auth/data/models/verify_user_response_model.dart';
import '../../features/auth/data/models/complete_profile_request_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/users/verify')
  Future<VerifyUserResponseModel> verifyUser(
    @Body() VerifyUserRequestModel request,
  );

  @POST('/users/complete_profile')
  Future<Response> completeProfile(
    @Body() CompleteProfileRequestModel request,
    @Header('Authorization') String? authorization,
  );
}
